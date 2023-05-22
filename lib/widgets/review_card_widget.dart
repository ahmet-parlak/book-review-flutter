import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../models/review_model.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(review.user?.photoUrl ?? ''),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(review.user?.name ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Text(DateFormat('dd.MM.yyyy')
                        .format(DateTime.parse(review.date ?? '')))
                  ],
                ),
                RatingBar.builder(
                  initialRating: review.rating?.toDouble() ?? 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemSize: 16,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(height: 5),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      review.review ?? '',
                      overflow: TextOverflow.clip,
                      softWrap: true,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
