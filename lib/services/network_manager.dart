import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;

class NetworkManager {
  late final Dio _dio;

  NetworkManager._() {
    _dio = Dio(BaseOptions(baseUrl: constants.apiBaseUrl));
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }

  static NetworkManager instance = NetworkManager._();

  Dio get service => _dio;

  void addBaseHeaderToToken(String token) {
    _dio.options.headers['Authorization'] = token;
  }
}
