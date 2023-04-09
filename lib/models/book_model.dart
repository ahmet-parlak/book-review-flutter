import 'package:book_review/models/publisher_model.dart';

import 'author_model.dart';

class Book {
  final int? id;
  final String? isbn;
  final String? title;
  final String? originalTitle;
  final Author? author;
  final String? translator;
  final String? publisherId;
  final Publisher? publisher;
  final String? publicationYear;
  final String? pages;
  final String? description;
  final String? photo;
  final String? language;
  final int? reviewCount;
  final int? rating;

  Book(
      {this.id,
      this.isbn,
      this.title,
      this.author,
      this.originalTitle,
      this.translator,
      this.publisherId,
      this.publicationYear,
      this.publisher,
      this.pages,
      this.description,
      this.photo,
      this.language,
      this.reviewCount,
      this.rating});

  Book.fromData(data)
      : id = data['id'].toInt(),
        isbn = data['isbn'].toString(),
        title = data['title'].toString(),
        author = Author.fromData(data['author']),
        originalTitle = data['original_title'].toString(),
        translator = data['translator'].toString(),
        publisherId = data['publisher_id'].toString(),
        publisher = Publisher.fromData(data['publisher']),
        publicationYear = data['publication_year'].toString(),
        pages = data['pages'].toString(),
        description = data['description'].toString(),
        photo = data['book_photo'].toString(),
        language = data['language'].toString(),
        reviewCount = data['review_count'].toInt(),
        rating = data['rating'].toInt();
}
