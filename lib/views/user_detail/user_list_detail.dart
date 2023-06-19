import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/models/book_list_model.dart';
import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/user_detail_list_data.dart';
import 'package:book_review/views/book_detail_page.dart';
import 'package:book_review/widgets/appbar/page_app_bar.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../../extensions/string_extension.dart';
import '../../models/user_model.dart';

class UserListDetail extends StatelessWidget {
  final User user;
  final BookList list;
  const UserListDetail({Key? key, required this.user, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetailListData(user: user, list: list),
      child: Scaffold(
        appBar: const PageAppBar(),
        body: Column(children: const [
          ListName(),
          Expanded(child: ListBooks()),
        ]),
      ),
    );
  }
}

class ListName extends StatelessWidget {
  const ListName({super.key});

  @override
  Widget build(BuildContext context) {
    BookList list = context.watch<UserDetailListData>().list;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.96,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            textAlign: TextAlign.center,
            (constants.defaultBookLists[list.name] ?? list.name).capitalize(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        )
      ],
    );
  }
}

class ListBooks extends StatefulWidget {
  const ListBooks({Key? key}) : super(key: key);

  @override
  State<ListBooks> createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        context.read<UserDetailListData>().nextPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = context.watch<UserDetailListData>().userListBooks;
    final isFetchingBooks =
        context.watch<UserDetailListData>().isFetchingListBooks;
    return isFetchingBooks
        ? const LoadingIndicatorWidget()
        : books.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Listeye Henüz Kitap Eklenmemiş',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: books.length + 1,
                itemBuilder: (context, index) {
                  Book? book = index < books.length ? books[index] : null;

                  return index < books.length
                      ? Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetailPage(book: book),
                                  ));
                            },
                            title: Row(
                              children: [
                                SizedBox(
                                    height: 84,
                                    width: 60,
                                    child: Image.network(
                                      book!.photo ?? '',
                                      fit: BoxFit.fitHeight,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }

                                        return const Center(
                                            child: LoadingIndicatorWidget());
                                      },
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Image.asset(
                                              constants.bookCoverNotAvailable),
                                    )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              book.author?.name ?? '-',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.fade,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              book.publisher?.name ?? '-',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RatingBar.builder(
                                                initialRating:
                                                    book.rating?.toDouble() ??
                                                        0,
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                ignoreGestures: true,
                                                itemCount: 5,
                                                itemSize: 14,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '(${book.reviewCount ?? ''})',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : context.watch<UserDetailListData>().isLoadingListBooks
                          ? const LoadingIndicatorWidget()
                          : const SizedBox();
                });
  }
}
