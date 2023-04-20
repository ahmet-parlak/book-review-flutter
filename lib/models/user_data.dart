import 'package:book_review/models/user_model.dart';
import 'package:book_review/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../consts/consts.dart' as constants;
import '../services/network_manager.dart';
import '../services/secure_storage.dart';
import 'book_list_model.dart';

class UserData with ChangeNotifier {
  static User? _user;
  static String? _token;
  static final List<BookList> _bookLists = [];

  User? get user => _user;

  String? get token => _token;

  List<BookList> get bookLists => _bookLists;

  Future<void> getUser() async {
    _token = await SecureStorage.instance.readToken();
    if (_token == null) {
      _user = null;
      return;
    }

    NetworkManager.instance.addBaseHeaderToToken('Bearer ${_token ?? ''}');
    try {
      final response =
          await NetworkManager.instance.service.get(constants.apiAuthUser);
      _user = User.fromData(response.data['user']);

      final List bookList = response.data['book_lists'];
      _bookLists.clear();
      for (var element in bookList) {
        _bookLists.add(BookList.fromData(element));
      }
    } on DioError catch (e) {
      _user = null;
    } finally {
      notifyListeners();
    }
  }

  void addListFromData(data) {
    _bookLists.add(BookList.fromData(data));
    notifyListeners();
  }

  Future<bool?> loginUser({required email, required password}) async {
    try {
      bool isLogin =
          await Auth.instance.login(email: email, password: password);
      if (isLogin) {
        getUser();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool?> logoutUser() async {
    try {
      await Auth.instance.logout();
      await getUser();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
