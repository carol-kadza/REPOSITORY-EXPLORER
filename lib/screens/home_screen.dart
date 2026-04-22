import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_repository_explorer/models/repo.dart';
import 'package:github_repository_explorer/services/db_service.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Repo> repos = [];
  bool loading = true;

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
        repos = await db.getRepos();
      } else {
        // first time online fetch
        repos = await fetchFromApi();
        await db.saveRepos(repos);
      }
    } catch (e) {
      // fallback if no internet
      repos = await db.getRepos();
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Repositories"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: repos.length,
              itemBuilder: (context, index) {
                final r = repos[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(r.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Owner: ${r.owner}"),
                        const SizedBox(height: 5),
                        Text(
                          r.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
