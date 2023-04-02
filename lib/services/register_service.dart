import 'package:book_review/responseMixin.dart';
import 'package:book_review/services/network_manager.dart';

class Register with ResponseMixin {
  final String email;
  final String name;
  final String password;
  final String passwordConfirmation;

  Register(
      {required this.email,
      required this.name,
      required this.password,
      required this.passwordConfirmation});

  Future<Map<String, dynamic>> register() async {
    final data = {
      'email': email,
      'name': name,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    final response =
        await NetworkManager.instance.service.post('/register', data: data);
    if (response.statusCode == 200) {
      if (response.data['success'] == true ||
          response.data['status'] == 'success') {
        return responseMap(success: true);
      } else {
        return responseMap(
            success: false,
            message: response.data['message'],
            data: response.data['data']);
      }
    } else {
      return responseMap(success: false, message: response.statusMessage);
    }
  }
}
