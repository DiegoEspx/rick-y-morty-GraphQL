class Character {
  final String id;
  final String name;
  final String status; // Alive | Dead | unknown
  final String species;
  final String image;
  final LocationRef? origin;
  final LocationRef? location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.origin,
    this.location,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'unknown',
      species: json['species'] ?? '',
      image: json['image'] ?? '',
      origin: json['origin'] != null ? LocationRef.fromJson(json['origin']) : null,
      location: json['location'] != null ? LocationRef.fromJson(json['location']) : null,
    );
  }
}

class LocationRef {
  final String? name;
  LocationRef({this.name});
  factory LocationRef.fromJson(Map<String, dynamic> json) =>
      LocationRef(name: json['name']);
}
