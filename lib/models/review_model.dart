import 'package:book_review/models/user_model.dart';

class Review {
  final User? user;
  final int? rating;
  final String? review;
  final String? date;

  Review({this.user, this.rating, this.review, this.date});

  Review.fromData(data)
      : rating = data['rating'],
        review = data['review'],
        date = data['updated_at'],
        user = data['user'] != null ? User.fromData(data['user']) : null;
}
