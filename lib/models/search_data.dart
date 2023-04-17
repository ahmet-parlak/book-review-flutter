import 'dart:collection';

import 'package:flutter/material.dart';

import 'book_model.dart';

class SearchData with ChangeNotifier {
  final List<Book> _books = [];
  String? _nextPageUrl;
  String? _prevPageUrl;

  UnmodifiableListView<Book> getBooks() => UnmodifiableListView(_books);

  void loadBook(books) {
    _books.clear();
    books.forEach((book) {
      _addBook(Book.fromData(book));
    });
  }

  void loadNextPage(books) {
    books.forEach((book) {
      _addBook(Book.fromData(book));
    });
    notifyListeners();
  }

  void _addBook(Book book) {
    _books.add(book);
  }

  void changeBook({required Book book, required int index}) {
    _books[index] = book;
    notifyListeners();
  }

  void setNextPageUrl(String? url) {
    _nextPageUrl = url;
  }

  void setPrevPageUrl(String? url) {
    _prevPageUrl = url;
  }

  String? getNextPageUrl() {
    return _nextPageUrl;
  }

  String? getPrevPageUrl() {
    return _prevPageUrl;
  }
}
