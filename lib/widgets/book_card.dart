import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../consts/consts.dart' as constants;
import '../models/book_model.dart';

class BookCardWidget extends StatelessWidget {
  const BookCardWidget({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Row(
        children: [
          SizedBox(
              height: 140,
              width: 100,
              child: Image.network(
                book.photo ?? '',
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: LoadingIndicatorWidget());
                },
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(constants.bookCoverNotAvailable),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(
                    book.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 3),
                  Text(book.author?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 1),
                  Text(book.publisher?.name ?? '',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: book.rating?.toDouble() ?? 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(width: 5),
                      Text('(${book.reviewCount ?? ''})')
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
