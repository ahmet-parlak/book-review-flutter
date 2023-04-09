class Publisher {
  final int? id;
  final String? name;
  final String? website;
  final String? description;
  final String? photo;

  Publisher({this.id, this.name, this.website, this.photo, this.description});

  Publisher.fromData(Map? data)
      : id = data?['id'],
        name = data?['publisher_name'],
        website = data?['website'],
        description = data?['description'],
        photo = data?['publisher_photo'];
}
