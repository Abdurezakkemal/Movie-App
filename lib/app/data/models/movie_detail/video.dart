class Video {
  final String id;
  final String name;
  final String site;
  final String key;

  Video({
    required this.id,
    required this.name,
    required this.site,
    required this.key,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      name: json['name'],
      site: json['site'],
      key: json['key'],
    );
  }
}
