import 'package:book_review/responseMixin.dart';
import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;

class Search with ResponseMixin {
  final String query;

  Search({required this.query});

  Future<Map<String, dynamic>> withQuery() async {
    final data = {'query': query};
    try {
      final response = await NetworkManager.instance.service
          .get(constants.apiSearch, queryParameters: data);
      if (response.statusCode == 200) {
        return responseMap(success: true, data: response.data);
      } else {
        return responseMap(success: false, message: response.statusMessage);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return responseMap(
            success: false,
            message: e.response!.data['message'],
            data: e.response!.data['errors']);
      } else {
        return responseMap(
            success: false,
            message: 'Arama işlemi sırasında bir hata meydana geldi',
            data: {'message': 'Arama işlemi sırasında bir hata meydana geldi'});
      }
    }
  }

  Future<Map<String, dynamic>> withUrl(String url) async {
    url = url.replaceAll(constants.localhostDomain, constants.baseUrlDomain);
    try {
      final response = await NetworkManager.instance.service.get(url);
      if (response.statusCode == 200) {
        return responseMap(success: true, data: response.data);
      } else {
        return responseMap(success: false, message: response.statusMessage);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return responseMap(
            success: false,
            message: e.response!.data['message'],
            data: e.response!.data['errors']);
      } else {
        return responseMap(
            success: false,
            message: 'Arama işlemi sırasında bir hata meydana geldi',
            data: {'message': 'Arama işlemi sırasında bir hata meydana geldi'});
      }
    }
  }
}
