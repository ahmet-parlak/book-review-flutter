import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/models/publisher_model.dart';
import 'package:book_review/models/review_model.dart';

import 'author_model.dart';

class Book {
  final int? id;
  final String? isbn;
  final String? title;
  final String? originalTitle;
  final Author? author;
  final String? translator;
  final int? publisherId;
  final Publisher? publisher;
  final String? publicationYear;
  final String? pages;
  final String? description;
  final String? photo;
  final String? language;
  final int? reviewCount;
  final double? rating;
  final List? categories;
  final Review? userReview;

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
      this.rating,
      this.categories,
      this.userReview});

  Book.fromData(data)
      : id = data['id'].toInt(),
        isbn = data['isbn'],
        title = data['title'],
        author = Author.fromData(data['author']),
        originalTitle = data['original_title'],
        translator = data['translator'],
        publisherId = data['publisher_id'],
        publisher = Publisher.fromData(data['publisher']),
        publicationYear = data['publication_year'],
        pages = data['pages'],
        description = data['description'],
        photo = data['book_photo']
            .toString()
            .replaceAll(constants.localhostDomain, constants.baseUrlDomain),
        language = data['language'],
        reviewCount = data['review_count'].toInt(),
        categories = data['categories'],
        rating = data['rating'].toDouble(),
        userReview = data['user_review'] != null
            ? Review.fromData(data['user_review'])
            : null;
}
