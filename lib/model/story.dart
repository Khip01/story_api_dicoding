class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final int lat;
  final int lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });
}