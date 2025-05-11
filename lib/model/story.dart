class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photoUrl: json['photoUrl'],
      createdAt: json['createdAt'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class ListStory {
  final List<Story>  listStory;

  ListStory({
    required this.listStory,
  });

  factory ListStory.fromJson(List<dynamic> listJson){
    List<Story> listFromJson = [];

    for(Map<String, dynamic> itemStory in listJson){
      listFromJson.add(Story.fromJson(itemStory));
    }

    return ListStory(listStory: listFromJson);
  }
}