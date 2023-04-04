import 'package:book_review/responseMixin.dart';
import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;

class ResetPassword with ResponseMixin {
  final String currentPassword;
  final String newPassword;
  final String passwordConfirmation;

  ResetPassword(
      {required this.currentPassword,
      required this.newPassword,
      required this.passwordConfirmation});

  Future<Map<String, dynamic>> reset() async {
    final data = {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': passwordConfirmation,
    };
    try {
      final response = await NetworkManager.instance.service
          .put(constants.apiResetUserPassword, data: data);
      if (response.statusCode == 200) {
        if (response.data['success'] == true ||
            response.data['message'] == 'success') {
          return responseMap(success: true);
        } else {
          return responseMap(
              success: false,
              message: response.data['message'],
              data: response.data['errors']);
        }
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
            message: 'Güncelleme işlemi sırasında bir hata meydana geldi',
            data: {
              'message': 'Güncelleme işlemi sırasında bir hata meydana geldi'
            });
      }
    }
  }
}
