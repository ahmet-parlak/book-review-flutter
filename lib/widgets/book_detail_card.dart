import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/models/create_review.dart';
import 'package:book_review/services/book_service.dart';
import 'package:book_review/widgets/dialogs/custom_alert_dialog.dart';
import 'package:book_review/widgets/review_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/book_model.dart';
import 'book_report_dialog.dart';
import 'loading_indicator.dart';

class BookDetailCardWidget extends StatelessWidget {
  const BookDetailCardWidget({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    void reviewSuccessDialog() {
      showDialog(
          context: context,
          builder: (context) =>
              const CustomAlertDialog(message: 'Değerlendirmeniz alındı'));
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
                            .titleLarge
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        Text('Yazar: ',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Expanded(
                          child: Text(book.author?.name ?? '',
                              overflow: TextOverflow.clip,
                              style: Theme.of(context).textTheme.titleMedium),
                        )
                      ]),
                      Row(children: [
                        Text('Yayınevi: ',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Expanded(
                          child: Text(book.publisher?.name ?? '',
                              overflow: TextOverflow.clip,
                              style: Theme.of(context).textTheme.titleMedium),
                        )
                      ]),
                      Row(children: [
                        Text('Kategori: ',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Expanded(
                          child: Text(
                              (book.categories?.isEmpty ?? true)
                                  ? '-'
                                  : book.categories!.join(','),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium),
                        )
                      ]),
                      Row(children: [
                        Text('Yayın Yılı: ',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(book.publicationYear ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium)
                      ]),
                      Row(children: [
                        Text('ISBN: ',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(book.isbn ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium)
                      ]),
                      Row(children: [
                        Text('Dil: ',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                            constants.language[book.language] ??
                                (book.language ?? ''),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium)
                      ]),
                      Row(children: [
                        Text('Sayfa Sayısı: ',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(book.pages ?? '-',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium)
                      ]),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: Text('Açıklama',
                            style: Theme.of(context).textTheme.headlineSmall),
                        children: [Text(book.description ?? '')],
                      ),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButton(
                            isExpanded: true,
                            icon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.arrow_drop_down_circle_rounded,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: null,
                                  child: Text('Kitabı Listeye Ekle')),
                              DropdownMenuItem(
                                  value: 'read', child: Text('Okundu')),
                              DropdownMenuItem(
                                  value: 'reading', child: Text('Okunuyor')),
                              DropdownMenuItem(
                                  value: 'to_read', child: Text('Okunacak')),
                              DropdownMenuItem(
                                  value: 'new_list',
                                  child: Text('Liste Oluştur')),
                            ],
                            onChanged: (value) {},
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
                                      reviewSuccessDialog();
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
                              onPressed: () async {},
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
}
