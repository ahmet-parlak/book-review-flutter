import 'package:book_review/consts/colors.dart' as colors;
import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/helpers/snackbar_helper.dart';
import 'package:book_review/models/book_data.dart';
import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/create_review.dart';
import 'package:book_review/models/my_lists_data.dart';
import 'package:book_review/services/book_service.dart';
import 'package:book_review/widgets/dialogs/custom_alert_dialog.dart';
import 'package:book_review/widgets/list_widgets/create_list_form.dart';
import 'package:book_review/widgets/review_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/book_list_model.dart';
import 'book_report_dialog.dart';
import 'loading_indicator.dart';

class BookDetailCardWidget extends StatelessWidget {
  const BookDetailCardWidget({super.key});

  //final Book book;

  @override
  Widget build(BuildContext context) {
    final book = context.watch<BookData>().book;
    final List<String> categories = [];
    final List? categoriesList = book.categories;
    final List userLists = context.watch<MyListsData>().bookLists;
    final List<DropdownMenuItem> bookListDropdownItems = [];
    final bookInfoHeadlineTheme =
        Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18);
    final bookInfoTheme = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w400);

    const infoSeperator = SizedBox(height: 4.0);

    for (var bookList in userLists) {
      bookListDropdownItems.add(buildDropdownMenuItem(bookList));
    }
    categoriesList?.forEach((category) {
      categories.add(category['category']['category_name']);
    });

    void showSuccessDialog({required String message}) {
      showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(message: message));
    }

    void showErrorDialog({required String message}) {
      showDialog(
          context: context,
          builder: (context) =>
              CustomAlertDialog(message: message, title: 'Hata'));
    }

    void bookAddedToListAction(Map isAdded) {
      if (isAdded['success']) {
        context.read<MyListsData>().fetchLists();
        SnackBarHelper.showSnackBar(
            context: context,
            message: isAdded['data'],
            icon: Icons.check_circle);
      } else {
        SnackBarHelper.showSnackBar(
            context: context,
            message: 'Kitap listeye eklenirken bir hata meydana geldi');
      }
    }

    return Card(
      elevation: 2,
      child: Column(
        children: [
          const SizedBox(height: 6),
          SizedBox(
              height: 160,
              width: 120,
              child: Image.network(
                book.photo ?? '',
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: LoadingIndicatorWidget());
                },
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(constants.bookCoverNotAvailable),
              )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
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
                      ),
                      const SizedBox(height: 6),
                      Text(
                        book.title ?? '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        Text('Yazar: ', style: bookInfoHeadlineTheme),
                        Expanded(
                          child: Text(book.author?.name ?? '',
                              overflow: TextOverflow.clip,
                              style: bookInfoTheme),
                        )
                      ]),
                      infoSeperator,
                      Row(children: [
                        Text('Yayınevi: ', style: bookInfoHeadlineTheme),
                        Expanded(
                          child: Text(book.publisher?.name ?? '',
                              overflow: TextOverflow.clip,
                              style: bookInfoTheme),
                        )
                      ]),
                      infoSeperator,
                      Row(children: [
                        Text('Kategori: ', style: bookInfoHeadlineTheme),
                        Expanded(
                          child: Text(
                              (categories.isEmpty)
                                  ? '-'
                                  : categories.join(", "),
                              overflow: TextOverflow.ellipsis,
                              style: bookInfoTheme),
                        )
                      ]),
                      infoSeperator,
                      Row(children: [
                        Text('Yayın Yılı: ', style: bookInfoHeadlineTheme),
                        Text(book.publicationYear ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: bookInfoTheme)
                      ]),
                      infoSeperator,
                      Row(children: [
                        Text('ISBN: ', style: bookInfoHeadlineTheme),
                        Text(book.isbn ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: bookInfoTheme)
                      ]),
                      infoSeperator,
                      Row(children: [
                        Text('Dil: ', style: bookInfoHeadlineTheme),
                        Text(
                            constants.bookLanguage[book.language] ??
                                (book.language ?? ''),
                            overflow: TextOverflow.ellipsis,
                            style: bookInfoTheme)
                      ]),
                      infoSeperator,
                      Row(children: [
                        Text('Sayfa Sayısı: ', style: bookInfoHeadlineTheme),
                        Text(book.pages ?? '-',
                            overflow: TextOverflow.ellipsis,
                            style: bookInfoTheme)
                      ]),
                      infoSeperator,
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: Text('Açıklama', style: bookInfoHeadlineTheme),
                        children: [Text(book.description ?? '')],
                      ),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                color: colors.dropDownWhite,
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton(
                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(
                                    Icons.arrow_drop_down_circle_rounded,
                                    size: 20,
                                    color: Theme.of(context).primaryColor),
                              ),
                              hint: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Kitabı Listeye Ekle',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                              dropdownColor:
                                  Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(8),
                              items: [
                                ...bookListDropdownItems,
                                DropdownMenuItem(
                                  value: 'create',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 0),
                                    decoration: const BoxDecoration(
                                        border: BorderDirectional(
                                            top: BorderSide(
                                                color: Colors.grey))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Yeni Liste Oluştur',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(Icons.add_box_rounded),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                              onChanged: (value) async {
                                if (value != null) {
                                  if (value == 'create') {
                                    String? listName =
                                        await showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20))),
                                            context: context,
                                            builder: (context) =>
                                                const CreateListFormWidget());
                                    if (listName?.isNotEmpty != null) {
                                      final response =
                                          await BookService(book.id)
                                              .createList(listName: listName!);

                                      if (response['success'] == true) {
                                        final data = response['data'];
                                        if (data['state'] == 'success') {
                                          showSuccessDialog(
                                              message: data['message']);
                                          if (data['newlist'] == 'true') {
                                            Provider.of<MyListsData>(context,
                                                    listen: false)
                                                .addListFromData(data['list']);
                                          }
                                        }
                                      } else {
                                        showErrorDialog(
                                            message: response['message'] ??
                                                'Bir hata meydana geldi');
                                      }
                                    }
                                  } else {
                                    final Map isAdded =
                                        await BookService(book.id)
                                            .addToList(listId: value);

                                    bookAddedToListAction(isAdded);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return BookReportDialogForm(bookId: book.id);
                                },
                              );
                            },
                            child: const Text('Hata Bildir'),
                          ),
                        )
                      ]),
                      //
                      const SizedBox(height: 10),
                      book.userReview == null
                          ? ElevatedButton(
                              onPressed: () async {
                                CreateReview? review =
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        context: context,
                                        builder: (context) =>
                                            const ReviewFormWidget());

                                if (review != null) {
                                  final response = await BookService(book.id)
                                      .reviewBook(review);

                                  if (response['success'] == true) {
                                    final data = response['data'];

                                    if (data['success'] == true) {
                                      context.read<BookData>().changeBook(
                                          Book.fromData(data['book']));
                                      context
                                          .read<BookData>()
                                          .loadReviews(data['book']['reviews']);
                                      showSuccessDialog(
                                          message: data['message'] ??
                                              'Değerlendirmeniz alındı');
                                    }
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Kitabı Değerlendir',
                                      textAlign: TextAlign.center),
                                  SizedBox(width: 10),
                                  Icon(Icons.rate_review_rounded, size: 20)
                                ],
                              ))
                          : ElevatedButton(
                              onPressed: () async {
                                CreateReview? review =
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        context: context,
                                        builder: (context) => ReviewFormWidget(
                                            currentReview: book.userReview));

                                if (review != null) {
                                  final response = await BookService(book.id)
                                      .editReview(review);

                                  if (response['success'] == true) {
                                    final data = response['data'];

                                    if (data['success'] == true) {
                                      context.read<BookData>().changeBook(
                                          Book.fromData(data['book']));
                                      context
                                          .read<BookData>()
                                          .loadReviews(data['book']['reviews']);
                                      showSuccessDialog(
                                          message: data['message'] ??
                                              'Değerlendirmeniz güncellendi');
                                    }
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Değerlendirmenizi Düzenleyin',
                                      textAlign: TextAlign.center),
                                  SizedBox(width: 10),
                                  Icon(Icons.rate_review_rounded, size: 20)
                                ],
                              ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  DropdownMenuItem buildDropdownMenuItem(BookList bookList) {
    return DropdownMenuItem(
        value: bookList.id,
        child:
            Text(constants.defaultBookLists[bookList.name] ?? bookList.name));
  }
}
