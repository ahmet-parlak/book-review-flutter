import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/helpers/snackbar_helper.dart';
import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/my_reviews_data.dart';
import 'package:book_review/views/book_detail_page.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MyReviews extends StatelessWidget {
  const MyReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int reviewCount = context.watch<MyReviewsData>().reviewCount;
    String headerText = '$reviewCount Adet Değerlendirmeniz Mevcut';
    String subtitle = reviewCount > 0
        ? 'Değerlendirmeyi kaldırmak için yana kaydırın.'
        : 'Henüz değerlendirme yapmadınız';
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(headerText)),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            )),
        const Expanded(child: ReviewsListView()),
      ],
    );
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
    await context.read<MyReviewsData>().loadMore();
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

  Future<void> refresh() async {
    await context.read<MyReviewsData>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    List reviews = context.watch<MyReviewsData>().myReviews;
    bool isNextPageExists = context.watch<MyReviewsData>().isNextPageExists;

    return RefreshIndicator(
      onRefresh: () => refresh(),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: listViewController,
          itemCount: reviews.length + 1,
          itemBuilder: (context, index) {
            if (index < reviews.length) {
              return ReviewCardWidget(book: reviews[index].book);
            } else {
              return isNextPageExists
                  ? const LoadingIndicatorWidget()
                  : const SizedBox();
            }
          }),
    );
  }
}

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    isRemovedAction(bool isRemoved) {
      if (isRemoved) {
        SnackBarHelper.showSnackBar(
            context: context,
            message: 'Değerlendirmeniz kaldırıldı',
            icon: Icons.check_circle);
      } else {
        SnackBarHelper.showSnackBar(
            context: context,
            message:
                'Değerlendirmeniz kaldırıldırılırken bir hata meydana geldi');
      }
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.delete_forever, color: Colors.white, size: 36),
            ),
          )),
      secondaryBackground: Container(
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_forever, color: Colors.white, size: 36),
            ),
          )),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Değerlendirmeniz kaldırılacak.'),
                    Text('Bu işlem geri alınamaz.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('İptal'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Kaldır'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        bool isRemoved =
            await context.read<MyReviewsData>().removeReview(book: book);
        isRemovedAction(isRemoved);
      },
      child: Card(
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
                    initialRating: book.userReview!.rating?.toDouble() ?? 0,
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
                  if (book.userReview!.review != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        book.userReview!.review ?? '',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
