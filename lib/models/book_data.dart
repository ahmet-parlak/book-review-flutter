import 'package:book_review/models/review_model.dart';
import 'package:flutter/material.dart';

import '../widgets/review_card_widget.dart';
import 'book_model.dart';

class BookData with ChangeNotifier {
  Book _book;

  final List<ReviewCard> _reviews = [];

  BookData(this._book);

  Book get book => _book;
  List<ReviewCard> get reviews => _reviews;

  void changeBook(Book book) {
    _book = book;
    notifyListeners();
  }

  void loadReviews(List reviews) {
    _reviews.clear();
    for (var review in reviews) {
      _reviews.add(ReviewCard(review: Review.fromData(review)));
    }
    notifyListeners();
  }
}
