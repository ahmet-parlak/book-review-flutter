import 'package:book_review/services/network_manager.dart';
import 'package:book_review/services/secure_storage.dart';
import 'package:dio/dio.dart';

import '../models/user_model.dart';
import 'device_info.dart';

class Auth {
  Future<User?> getUser() async {
    String? token = await SecureStorage.instance.readToken();
    if (token == null) return null;
    NetworkManager.instance.addBaseHeaderToToken('Bearer ' + token);

    try {
      final response = await NetworkManager.instance.service.get('/user');
      return User.fromData(response.data['user']);
    } on DioError catch (e) {
      return null;
    }
  }

  Future<bool> login({required email, required password}) async {
    late final String? token;
    try {
      final deviceName = await DeviceInfo().getDeviceModel();
      final response = await NetworkManager.instance.service.post('/auth',
          data: {
            'email': email,
            'password': password,
            'device_name': deviceName
          });
      if (response.statusCode != 200) {
        return false;
      } else {
        token = response.data;
      }
    } catch (e) {
      return false;
    }

    if (token != null) {
      return await SecureStorage.instance.writeToken(token.toString());
    } else {
      return false;
    }
  }

  Future<bool> isLogged() async {
    String? token = await SecureStorage.instance.readToken();
    if (token == null) return false;
    print(token);
    return true;
  }

  Future<bool> logout() async {
    return await SecureStorage.instance.deleteToken();
  }
}
