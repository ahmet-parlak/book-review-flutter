mixin ResponseMixin {
  Map<String, dynamic> responseMap(
      {required bool success, String? message, dynamic data}) {
    return {'success': success, 'message': message, 'data': data};
  }
}
