class User {
  final String? id;
  final String? name;
  final String? email;
  final String? about;
  final String? photoUrl;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.about});

  User.fromData(data)
      : email = data['email'].toString(),
        about = data['about'].toString(),
        name = data['name'].toString(),
        id = data['id'].toString(),
        photoUrl = data['profile_photo_url'].toString();
}
