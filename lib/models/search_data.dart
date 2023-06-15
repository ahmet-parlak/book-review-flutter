import 'dart:collection';

import 'package:flutter/material.dart';

import 'book_model.dart';

class SearchData with ChangeNotifier {
  final List<Book> _books = [];
  String? _query;
  String? _nextPageUrl;
  String? _prevPageUrl;

  UnmodifiableListView<Book> getBooks() => UnmodifiableListView(_books);
  String? get query => _query;

  void setQuery(String text) {
    _query = text;
  }

  void resetQuery() {
    _query = null;
  }

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
