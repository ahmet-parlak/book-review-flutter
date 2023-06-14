import 'package:book_review/models/book_list_model.dart';
import 'package:book_review/services/network_manager.dart';
import 'package:flutter/material.dart';

import '../consts/consts.dart' as constants;

class MyListsData extends ChangeNotifier {
  final List<BookList> _bookLists = [];

  List<BookList> get bookLists => _bookLists;

  MyListsData() {
    fetchLists();
  }

  void fetchLists() async {
    try {
      final response =
          await NetworkManager.instance.service.get(constants.apiGetLists);
      final List bookList = response.data['book_lists'];
      _bookLists.clear();
      for (var element in bookList) {
        _bookLists.add(BookList.fromData(element));
      }
      notifyListeners();
    } catch (e) {}
  }

  void addListFromData(data) {
    _bookLists.add(BookList.fromData(data));
    notifyListeners();
  }

  void removeList(id) {
    final List temp = List.from(_bookLists);
    _bookLists.clear();
    temp.where((list) => list.id != id).forEach((list) => _bookLists.add(list));
    notifyListeners();
  }
}
