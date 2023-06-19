import 'package:book_review/responseMixin.dart';
import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;

class UserDetailService with ResponseMixin {
  UserDetailService();

  Future<Map<String, dynamic>> userDetail(userId) async {
    try {
      final response = await NetworkManager.instance.service
          .get(constants.apiUserDetail(userId));
      if (response.data['state'] == 'success') {
        return responseMap(success: true, data: response.data['data']);
      } else {
        return responseMap(success: false, message: 'Hata meydana geldi');
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
            message: 'Kullanıcı bulunamadı',
            data: {'message': 'Kullanıcı bulunamadı'});
      }
    }
  }

  Future<Map<String, dynamic>> userList({
    String? url,
    required String userId,
    required String listId,
  }) async {
    url = url?.replaceAll(constants.localhostDomain, constants.baseUrlDomain) ??
        constants.apiUserDetailList(userId: userId, listId: listId);
    try {
      final response = await NetworkManager.instance.service.get(url);
      if (response.statusCode == 200) {
        return responseMap(success: true, data: response.data['data']);
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
            message: 'Liste bulunamadı',
            data: {'message': 'Liste bulunamadı'});
      }
    }
  }

  Future<Map<String, dynamic>> userReviews(userId, {String? url}) async {
    url = url?.replaceAll(constants.localhostDomain, constants.baseUrlDomain) ??
        constants.apiUserDetailReviews(userId: userId);
    try {
      final response = await NetworkManager.instance.service.get(url);
      if (response.data['state'] == 'success') {
        return responseMap(success: true, data: response.data['data']);
      } else {
        return responseMap(success: false, message: 'Hata meydana geldi');
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
            message: 'Hata meydana geldi',
            data: {'message': 'Hata meydana geldi'});
      }
    }
  }
}
