class Repo {
  final int id;
  final String name;
  final String fullName;
  final String url;
  final String owner;
  final String description;

  const Repo({
    required this.id,
    required this.name,
    required this.fullName,
    required this.url,
    required this.owner,
    required this.description,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      url: json['html_url'] as String? ?? '',
      owner: (json['owner'] as Map<String, dynamic>?)?['login'] as String? ?? '',
      description: json['description'] as String? ?? 'No description',
    );
  }

  factory Repo.fromMap(Map<String, dynamic> map) {
    return Repo(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      url: map['url'] as String? ?? '',
      owner: map['owner'] as String? ?? '',
      description: map['description'] as String? ?? 'No description',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'url': url,
      'owner': owner,
      'description': description,
    };
  }
}
