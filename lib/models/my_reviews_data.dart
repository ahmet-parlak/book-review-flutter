import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/my_review_model.dart';
import 'package:book_review/services/network_manager.dart';
import 'package:flutter/cupertino.dart';

import '../consts/consts.dart' as constants;

class MyReviewsData extends ChangeNotifier {
  final List<MyReview> _myReviews = [];
  int _reviewCount = 0;
  String? _nextPageUrl;

  List<MyReview> get myReviews => _myReviews;
  int get reviewCount => _reviewCount;
  bool get isNextPageExists => _nextPageUrl != null ? true : false;

  MyReviewsData() {
    _fetchMyReviews();
  }

  Future<void> _fetchMyReviews() async {
    try {
      final response =
          await NetworkManager.instance.service.get(constants.apiGetMyReviews);
      final List reviewList = response.data['data'];
      _reviewCount = response.data['total'];
      _nextPageUrl = response.data['next_page_url'];

      _myReviews.clear();
      for (var review in reviewList) {
        _myReviews.add(MyReview(book: Book.fromData(review['book'])));
      }
      notifyListeners();
    } catch (e) {}
  }

  Future<void> loadMore() async {
    if (_nextPageUrl != null) {
      try {
        final response =
            await NetworkManager.instance.service.get(_nextPageUrl!);
        final List reviewList = response.data['data'];
        _reviewCount = response.data['total'];
        _nextPageUrl = response.data['next_page_url'];
        for (var review in reviewList) {
          _myReviews.add(MyReview(book: Book.fromData(review['book'])));
        }
        notifyListeners();
      } catch (e) {}
    }
  }

  Future<bool> removeReview({required Book book}) async {
    try {
      final response = await NetworkManager.instance.service
          .delete(constants.apiRemoveReview(bookId: book.id));

      final state = response.data['state'];

      if (state == 'success') {
        _fetchMyReviews();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  refresh() {
    _fetchMyReviews();
  }
}
