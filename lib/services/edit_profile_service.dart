import 'package:book_review/responseMixin.dart';
import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;

class EditProfile with ResponseMixin {
  final String email;
  final String name;
  final String? photoPath;

  EditProfile({required this.email, required this.name, this.photoPath});

  Future<Map<String, dynamic>> update() async {
    late final data;
    if (photoPath == null) {
      data = {
        'email': email,
        'name': name,
      };
    } else {
      data = FormData.fromMap({
        'email': email,
        'name': name,
        'photo': await MultipartFile.fromFile(photoPath!)
      });
    }

    try {
      final response = await NetworkManager.instance.service
          .post(constants.apiUpdateUserProfile, data: data);
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
      return responseMap(
          success: false,
          message: e.response?.data['message'],
          data: e.response?.data['errors']);
    }
  }
}
