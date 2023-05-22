import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'book_model.dart';

class HomeData extends ChangeNotifier {
  final List<Map> _homeData = [];

  List<Map> get homeData => _homeData;

  HomeData() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await NetworkManager.instance.service.get(constants.homeData);
      if (response.data['state'] == 'success') {
        final List data = response.data['data'];

        for (var element in data) {
          List rawBooks = element["books"];
          List<Book> books = [];
          for (var rawBook in rawBooks) {
            books.add(Book.fromData(rawBook));
          }
          Map<String, dynamic> section = {
            "title": element['title'],
            "books": books
          };
          _homeData.add(section);
        }
        notifyListeners();
      }
    } on DioError catch (e) {}
  }
}
