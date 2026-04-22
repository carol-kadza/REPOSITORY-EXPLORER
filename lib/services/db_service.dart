import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:github_repository_explorer/models/repo.dart';

class DB {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'repos.db');

    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE repos(
            id INTEGER PRIMARY KEY,
            name TEXT,
            fullName TEXT,
            url TEXT,
            owner TEXT,
            avatarUrl TEXT,
            isPrivate INTEGER DEFAULT 0,
            description TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE repos ADD COLUMN avatarUrl TEXT DEFAULT ""',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE repos ADD COLUMN isPrivate INTEGER DEFAULT 0',
          );
        }
      },
    );
  }

  Future<void> saveRepos(List<Repo> repos) async {
    final db = await database;

    for (var r in repos) {
      await db.insert(
        'repos',
        r.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Repo>> getRepos() async {
    final db = await database;
    final data = await db.query('repos');

    return data.map((e) => Repo.fromMap(e)).toList();
  }

  Future<bool> hasData() async {
    final db = await database;
    final data = await db.query('repos');
    return data.isNotEmpty;
  }
}
