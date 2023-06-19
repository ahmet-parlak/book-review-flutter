import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/review_model.dart';
import 'package:book_review/models/user_detail_data.dart';
import 'package:book_review/views/book_detail_page.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class UserReviews extends StatelessWidget {
  const UserReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return const Text('User Reviews');
    return const ReviewsListView();
  }
}

class ReviewsListView extends StatefulWidget {
  const ReviewsListView({super.key});

  @override
  State<ReviewsListView> createState() => _ReviewsListViewState();
}

class _ReviewsListViewState extends State<ReviewsListView> {
  final listViewController = ScrollController();

  Future loadMore() async {
    await context.read<UserDetailData>().loadMoreUserReviews();
  }

  @override
  void initState() {
    listViewController.addListener(() {
      if (listViewController.position.maxScrollExtent ==
          listViewController.offset) {
        loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List reviews = context.watch<UserDetailData>().userReviews;
    bool isNextPageExists = context.watch<UserDetailData>().isNextPageExists;

    return reviews.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: listViewController,
            itemCount: reviews.length + 1,
            itemBuilder: (context, index) {
              if (index < reviews.length) {
                return ReviewCardWidget(
                  book: reviews[index]['book'],
                  review: reviews[index]['review'],
                );
              } else {
                return isNextPageExists
                    ? const LoadingIndicatorWidget()
                    : const SizedBox();
              }
            })
        : Text('Kullanıcının henüz değerlendirmesi bulunmuyor.');
  }
}

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({
    super.key,
    required this.book,
    required this.review,
  });

  final Book book;
  final Review review;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailPage(book: book),
              ));
        },
        title: Row(
          children: [
            SizedBox(
                height: 84,
                width: 60,
                child: Image.network(
                  book.photo ?? '',
                  fit: BoxFit.fitHeight,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(child: LoadingIndicatorWidget());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(constants.bookCoverNotAvailable),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          book.title ?? '-',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          book.author?.name ?? '-',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          book.publisher?.name ?? '-',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar.builder(
                            initialRating: book.rating?.toDouble() ?? 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemSize: 14,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '(${book.reviewCount ?? ''})',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 86,
                child: VerticalDivider(
                    color: Theme.of(context).primaryColor, thickness: 1.5)),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: review.rating?.toDouble() ?? 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemSize: 16,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                /*if (review.review != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      review.review ?? '',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )*/
              ],
            ))
          ],
        ),
      ),
    );
  }
}
