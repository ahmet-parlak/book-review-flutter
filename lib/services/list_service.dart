import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;
import '../models/book_list_model.dart';

class ListService {
  static ListService? _instance;

  static ListService get instance {
    if (_instance == null) _instance = ListService._init();
    return _instance!;
  }

  ListService._init();

  Future fetchBooks({required id}) async {
    try {
      final response = await NetworkManager.instance.service
          .get(constants.apiShowBookList(id));
      if (response.data['state'] == 'success') {
        return response.data['list'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> addBook({required listId, required bookId}) async {
    try {
      final response = await NetworkManager.instance.service
          .get(constants.apiListAddBook(id: listId, book: bookId));
      return response.data['state'] == 'success' ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeBook({required listId, required bookId}) async {
    try {
      final response = await NetworkManager.instance.service
          .get(constants.apiListRemoveBook(id: listId, book: bookId));
      return response.data['state'] == 'success' ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeList({required id}) async {
    try {
      final response = await NetworkManager.instance.service
          .delete(constants.apiDeleteBookList(id));
      return response.data['state'] == 'success' ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<BookList?> toggleListStatus({required id, required status}) async {
    try {
      final data = FormData.fromMap({'status': status});
      final response = await NetworkManager.instance.service.post(
        constants.apiUpdateBookList(id),
        data: data,
      );
      return response.data['state'] == 'success'
          ? BookList.fromData(response.data['list'])
          : null;
    } catch (e) {
      return null;
    }
  }

  updateListName({required id, required String name}) async {
    try {
      final data = FormData.fromMap({'list_name': name});
      final response = await NetworkManager.instance.service.post(
        constants.apiUpdateBookList(id),
        data: data,
      );
      return response.data['state'] == 'success'
          ? BookList.fromData(response.data['list'])
          : null;
    } catch (e) {
      return null;
    }
  }
}
