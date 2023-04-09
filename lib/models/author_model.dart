class Author {
  final int? id;
  final String? name;
  final String? country;
  final String? birthYear;
  final String? deathYear;
  final String? description;
  final String? photo;

  Author(
      {this.id,
      this.name,
      this.country,
      this.birthYear,
      this.deathYear,
      this.photo,
      this.description});

  Author.fromData(Map? data)
      : id = data?['id'],
        name = data?['author_name'],
        country = data?['country'],
        birthYear = data?['birth_year'],
        deathYear = data?['death_year'],
        description = data?['description'],
        photo = data?['author_photo'];
}
