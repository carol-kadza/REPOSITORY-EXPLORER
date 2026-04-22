import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_repository_explorer/models/repo.dart';
import 'package:github_repository_explorer/screens/detail_screen.dart';
import 'package:github_repository_explorer/services/db_service.dart';
import 'package:github_repository_explorer/widgets/repo_tile.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Repo> allRepos = [];
  List<Repo> repos = [];
  bool loading = true;
  String query = '';

  final DB db = DB();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<List<Repo>> fetchFromApi() async {
    final res = await http.get(
      Uri.parse('https://api.github.com/repositories'),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Repo.fromJson(e)).toList();
    } else {
      throw Exception('API failed');
    }
  }

  Future<void> loadData() async {
    try {
      // If we already have data, just use it (offline mode)
      if (await db.hasData()) {
        allRepos = await db.getRepos();
      } else {
        // first time online fetch
        allRepos = await fetchFromApi();
        await db.saveRepos(allRepos);
      }
    } catch (e) {
      // fallback if no internet
      allRepos = await db.getRepos();
    }

    repos = List.of(allRepos);
    setState(() => loading = false);
  }

  void filterRepos(String value) {
    final trimmed = value.trim().toLowerCase();

    setState(() {
      query = value;
      repos = allRepos.where((repo) {
        return repo.name.toLowerCase().contains(trimmed) ||
            repo.owner.toLowerCase().contains(trimmed) ||
            repo.fullName.toLowerCase().contains(trimmed);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Repositories"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: filterRepos,
                    decoration: InputDecoration(
                      hintText: 'Search repositories or owners',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () => filterRepos(''),
                              icon: const Icon(Icons.clear),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: repos.isEmpty
                      ? const Center(
                          child: Text('No repositories match your search.'),
                        )
                      : ListView.builder(
                          itemCount: repos.length,
                          itemBuilder: (context, index) {
                            final repo = repos[index];

                            return RepoTile(
                              repo: repo,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(repo: repo),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
