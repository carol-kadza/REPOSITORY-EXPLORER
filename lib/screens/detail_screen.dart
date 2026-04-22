import 'package:flutter/material.dart';
import 'package:github_repository_explorer/models/repo.dart';

class DetailScreen extends StatelessWidget {
  final Repo repo;

  const DetailScreen({
    super.key,
    required this.repo,
  });

  @override
  Widget build(BuildContext context) {
    final visibilityColor = repo.isPrivate ? Colors.orange : Colors.green;
    final visibilityLabel = repo.isPrivate ? 'Private repository' : 'Public repository';

    return Scaffold(
      appBar: AppBar(
        title: Text(repo.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    repo.avatarUrl.isNotEmpty ? NetworkImage(repo.avatarUrl) : null,
                child: repo.avatarUrl.isEmpty
                    ? Text(
                        repo.owner.isNotEmpty
                            ? repo.owner[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 28),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              repo.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Owner: ${repo.owner}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  repo.isPrivate ? Icons.lock : Icons.public,
                  color: visibilityColor,
                ),
                const SizedBox(width: 8),
                Text(
                  visibilityLabel,
                  style: TextStyle(
                    color: visibilityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Repository URL: ${repo.url}'),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              repo.description.isNotEmpty ? repo.description : 'No description',
            ),
          ],
        ),
      ),
    );
  }
}
