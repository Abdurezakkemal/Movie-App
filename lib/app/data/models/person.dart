class Person {
  final int id;
  final String name;
  final String? profilePath;
  final String? knownForDepartment;

  Person({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      knownForDepartment: json['known_for_department'],
    );
  }
}
