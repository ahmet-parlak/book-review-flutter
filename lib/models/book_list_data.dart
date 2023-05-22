import 'package:book_review/models/book_model.dart';
import 'package:book_review/services/list_service.dart';
import 'package:flutter/cupertino.dart';

import 'book_list_model.dart';

class BookListData extends ChangeNotifier {
  BookList _list;
  final List _books = [];
  late bool? _isPrivate;
  bool _isFatchingBooks = false;
  BookListData(this._list) {
    fetchBooks();
    _isPrivate = _list.status == 'private' ? true : false;
  }

  BookList get list => _list;
  List get books => _books;
  bool? get isPrivate => _isPrivate;
  bool get isFetchingBooks => _isFatchingBooks;

  Future<void> fetchBooks() async {
    _isFatchingBooks = true;

    notifyListeners();
    final responseList = await ListService.instance.fetchBooks(id: _list.id);

    if (responseList != null) {
      final rawBooks = responseList['books'];
      _books.clear();
      rawBooks.forEach((rawBook) {
        _books.add(Book.fromData(rawBook['book']));
      });
    }
    _isFatchingBooks = false;

    notifyListeners();
  }

  Future<bool> changeName(String name) async {
    final responseBookList =
        await ListService.instance.updateListName(id: _list.id, name: name);
    if (responseBookList != null) {
      _list = responseBookList;
      return true;
    }
    notifyListeners();
    return false;
  }

  toggleListStatus() async {
    _isPrivate = null;
    notifyListeners();
    final responseBookList = await ListService.instance
        .toggleListStatus(id: _list.id, status: _list.status);
    if (responseBookList != null) {
      _list = responseBookList;
      _isPrivate = _list.status == 'private' ? true : false;
    }
    notifyListeners();
  }

  Future<bool> removeBook({required book}) async {
    final bool isRemoved =
        await ListService.instance.removeBook(listId: _list.id, bookId: book);
    return isRemoved;
  }

  Future<bool> addBook({required book}) async {
    final bool isAdded =
        await ListService.instance.removeBook(listId: _list.id, bookId: book);
    return isAdded;
  }

  Future<bool> deleteList() async {
    final bool isRemoved = await ListService.instance.removeList(id: _list.id);
    return isRemoved;
  }
}
