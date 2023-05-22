import 'package:book_review/services/book_service.dart';
import 'package:book_review/widgets/appbar/page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_data.dart';
import '../models/book_model.dart';
import '../widgets/book_detail_card.dart';

class BookDetailPage extends StatelessWidget {
  BookDetailPage({Key? key, required this.book}) : super(key: key);
  Book book;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookData>(
      create: (context) => BookData(book),
      child: const BookDetailPageScaffold(),
    );
  }
}

class BookDetailPageScaffold extends StatefulWidget {
  const BookDetailPageScaffold({
    super.key,
  });

  @override
  State<BookDetailPageScaffold> createState() => _BookDetailPageScaffoldState();
}

class _BookDetailPageScaffoldState extends State<BookDetailPageScaffold> {
  void setBook(Book book) {
    Provider.of<BookData>(context, listen: false).changeBook(book);
  }

  void setReviews(List reviews) {
    Provider.of<BookData>(context, listen: false).loadReviews(reviews);
  }

  void getBook() async {
    final response =
        await BookService(context.read<BookData>().book.id ?? 0).getBook();

    if (response['success'] == true) {
      setBook(Book.fromData(response['data']['book']));
      final List reviews = response['data']['book']['reviews'];
      setReviews(reviews);
    }
  }

  @override
  void initState() {
    super.initState();
    getBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        const BookDetailCardWidget(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).primaryColor),
            child: Text(
              'Değerlendirmeler (${context.watch<BookData>().book.reviewCount})',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Column(
          children: Provider.of<BookData>(context).reviews,
        ),
      ]),
    );
  }
}
