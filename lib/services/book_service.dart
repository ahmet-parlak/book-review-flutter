import 'package:book_review/models/create_review.dart';
import 'package:book_review/responseMixin.dart';
import 'package:book_review/services/network_manager.dart';
import 'package:dio/dio.dart';

import '../consts/consts.dart' as constants;

class BookService with ResponseMixin {
  final int? id;

  BookService(this.id);

  Future<Map> getBook() async {
    try {
      final response = await NetworkManager.instance.service
          .get('${constants.apiGetBook}/$id');
      return responseMap(success: true, data: response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return responseMap(
            success: false,
            message: e.response!.data['message'],
            data: e.response!.data['errors']);
      } else {
        return responseMap(
            success: false,
            message: 'Bir hata meydana geldi',
            data: {'message': 'Bir hata meydana geldi'});
      }
    }
  }

  Future<Map> reportBook(List<String> reportedKeys) async {
    try {
      Map data = {"report_data": id, "reports": []};
      for (int i = 0; i < reportedKeys.length; i++) {
        Map<String, String> newKey = {"name": reportedKeys[i]};
        data['reports'].add(newKey);
      }

      final response = await NetworkManager.instance.service
          .post('${constants.apiGetBook}/$id/report', data: data);
      return responseMap(success: true, data: response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return responseMap(
            success: false,
            message: e.response!.data['message'],
            data: e.response!.data['errors']);
      } else {
        return responseMap(
            success: false,
            message: 'Bir hata meydana geldi',
            data: {'message': 'Bir hata meydana geldi'});
      }
    }
  }

  Future<Map> reviewBook(CreateReview review) async {
    try {
      Map data = {"book": id, "rating": review.rating, "review": review.review};

      final response = await NetworkManager.instance.service
          .post('${constants.apiGetBook}/$id/review', data: data);
      return responseMap(success: true, data: response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return responseMap(
            success: false,
            message: e.response!.data['message'],
            data: e.response!.data['errors']);
      } else {
        return responseMap(
            success: false,
            message: 'Bir hata meydana geldi',
            data: {'message': 'Bir hata meydana geldi'});
      }
    }
  }

  Future<Map> editReview(CreateReview review) async {
    try {
      Map data = {"book": id, "rating": review.rating, "review": review.review};

      final response = await NetworkManager.instance.service
          .put('${constants.apiGetBook}/$id/review', data: data);
      return responseMap(success: true, data: response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return responseMap(
            success: false,
            message: e.response!.data['message'],
            data: e.response!.data['errors']);
      } else {
        return responseMap(
            success: false,
            message: 'Bir hata meydana geldi',
            data: {'message': 'Bir hata meydana geldi'});
      }
    }
  }
}
