import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repo.dart';

class ApiService {
  final String url = "https://api.github.com/repositories";

  Future<List<Repo>> fetchRepositories() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      
      return data.map((json) => Repo.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load the repositories");
    }
  }
}