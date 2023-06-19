import 'package:book_review/models/book_list_model.dart';
import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/user_model.dart';
import 'package:book_review/services/user_detail_service.dart';
import 'package:flutter/material.dart';

class UserDetailListData with ChangeNotifier {
  User? user;
  BookList list;
  String? _nextPageUrl;

  final List<Book> _userListBooks = [];
  List<Book> get userListBooks => _userListBooks;
  bool _isFetchingListBooks = false;
  bool get isFetchingListBooks => _isFetchingListBooks;
  bool _isLoadingListBooks = false;
  bool get isLoadingListBooks => _isLoadingListBooks;

  UserDetailListData({required this.user, required this.list}) {
    fetchList();
  }

  Future fetchList() async {
    if (user == null || user?.id == null) return; //nullcheck
    UserDetailService service = UserDetailService();

    _isFetchingListBooks = true;
    notifyListeners();

    Map data =
        await service.userList(userId: user!.id!, listId: list.id.toString());
    _isFetchingListBooks = false;

    if (data['success'] == true) {
      data = data['data']['books'];
      _nextPageUrl = data['next_page_url'];
      final List books = data['data'];
      _userListBooks.clear();
      for (var book in books) {
        _userListBooks.add(Book.fromData(book['book']));
      }
    }
    notifyListeners();
  }

  Future nextPage() async {
    if (user == null || user?.id == null || _nextPageUrl == null)
      return; //nullcheck

    UserDetailService service = UserDetailService();

    _isLoadingListBooks = true;
    notifyListeners();

    Map data = await service.userList(
        userId: user!.id!, listId: list.id.toString(), url: _nextPageUrl);
    _isLoadingListBooks = false;

    if (data['success'] == true) {
      data = data['data']['books'];

      _nextPageUrl = data['next_page_url'];
      final List books = data['data'];

      for (var book in books) {
        _userListBooks.add(Book.fromData(book['book']));
      }
    }
    notifyListeners();
  }
}
