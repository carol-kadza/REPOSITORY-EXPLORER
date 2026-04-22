import 'package:flutter/material.dart';
import 'package:github_repository_explorer/models/repo.dart';

class RepoTile extends StatelessWidget {
  final Repo repo;
  final VoidCallback onTap;

  const RepoTile({
    super.key,
    required this.repo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visibilityColor = repo.isPrivate ? Colors.orange : Colors.green;
    final visibilityLabel = repo.isPrivate ? 'Private' : 'Public';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          backgroundImage:
              repo.avatarUrl.isNotEmpty ? NetworkImage(repo.avatarUrl) : null,
          child: repo.avatarUrl.isEmpty
              ? Text(
                  repo.owner.isNotEmpty ? repo.owner[0].toUpperCase() : '?',
                )
              : null,
        ),
        title: Text(repo.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Owner: ${repo.owner}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  repo.isPrivate ? Icons.lock : Icons.public,
                  size: 16,
                  color: visibilityColor,
                ),
                const SizedBox(width: 6),
                Text(
                  visibilityLabel,
                  style: TextStyle(
                    color: visibilityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              repo.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
