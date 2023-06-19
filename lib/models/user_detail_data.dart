import 'package:book_review/models/book_list_model.dart';
import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/review_model.dart';
import 'package:book_review/models/user_model.dart';
import 'package:book_review/services/user_detail_service.dart';
import 'package:flutter/material.dart';

class UserDetailData with ChangeNotifier {
  User? user;
  final List<BookList> _userLists = [];
  List<BookList> get userLists => _userLists;

  final List _userReviews = [];
  List get userReviews => _userReviews;
  String? _userReviewsNextPageUrl;
  bool get isNextPageExists => _userReviewsNextPageUrl != null ? true : false;
  bool _isUserReviewExist = true;
  bool get isUserReviewExist => _isUserReviewExist;

  final List<Book> _userListBooks = [];
  List<Book> get userListBooks => _userListBooks;
  bool _isFetchingListBooks = false;
  bool get isFetchingListBooks => _isFetchingListBooks;

  bool _isUserListExist = true;
  bool get isUserListExist => _isUserListExist;

  UserDetailData(this.user) {
    fetchUser();
    fetchUserReviews();
  }

  Future fetchUser() async {
    if (user == null) return;
    UserDetailService service = UserDetailService();

    Map data = await service.userDetail(user!.id);
    if (data['success'] != true) return;
    data = data['data'];
    final List lists = data['lists'];
    _userLists.clear();
    for (var element in lists) {
      _userLists.add(BookList.fromData(element));
    }
    if (_userLists.isEmpty) _isUserListExist = false;
    notifyListeners();
  }

  Future fetchUserReviews() async {
    if (user == null) return;
    UserDetailService service = UserDetailService();

    Map data = await service.userReviews(user!.id);
    if (data['success'] != true) return;
    data = data['data'];
    _userReviewsNextPageUrl = data['next_page_url'];
    final List reviews = data['data'];

    _userReviews.clear();
    for (var element in reviews) {
      Map review = {
        'review': Review.fromData(element),
        'book': Book.fromData(element['book'])
      };
      _userReviews.add(review);
    }
    if (_userReviews.isEmpty) _isUserReviewExist = false;
    notifyListeners();
  }

  Future loadMoreUserReviews() async {
    if (user == null || _userReviewsNextPageUrl == null) return; //null check
    UserDetailService service = UserDetailService();

    Map data =
        await service.userReviews(user!.id, url: _userReviewsNextPageUrl);
    if (data['success'] != true) return;
    data = data['data'];
    _userReviewsNextPageUrl = data['next_page_url'];
    final List reviews = data['data'];

    for (var element in reviews) {
      Map review = {
        'review': Review.fromData(element),
        'book': Book.fromData(element['book'])
      };
      _userReviews.add(review);
    }
    notifyListeners();
  }
}
