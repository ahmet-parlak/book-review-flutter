import 'package:book_review/services/network_manager.dart';
import 'package:book_review/services/secure_storage.dart';

import '../consts/consts.dart' as constants;
import 'device_info.dart';

class Auth {
  static Auth? _instance;

  Auth._();

  static Auth get instance {
    if (_instance == null) _instance = Auth._();
    return _instance!;
  }

  Future<bool> login({required email, required password}) async {
    //token request
    late final String? token;
    try {
      final deviceName = await DeviceInfo().getDeviceModel();
      final response = await NetworkManager.instance.service
          .post(constants.apiAuth, data: {
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
      rethrow;
      return false;
    }

    //token save
    if (token != null) {
      return await SecureStorage.instance.writeToken(token.toString());
    } else {
      return false;
    }
  }

  Future<bool> isLogged() async {
    String? token = await SecureStorage.instance.readToken();
    if (token == null) return false;
    return true;
  }

  Future<bool> logout() async {
    return await SecureStorage.instance.deleteToken();
  }
}
