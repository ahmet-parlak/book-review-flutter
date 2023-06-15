import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;

class BookRequestService {
  final String isbn;
  final String title;
  final String author;
  final String publisher;

  BookRequestService(
      {required this.isbn,
      required this.title,
      required this.author,
      required this.publisher});

  Future<bool> createBookRequest() async {
    final data = {
      'isbn': this.isbn,
      'title': this.title,
      'author': this.author,
      'publisher': this.publisher
    };

    try {
      final response = await NetworkManager.instance.service
          .post(constants.apiBookRequest, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    }
  }
}
