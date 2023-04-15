import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/models/review_model.dart';
import 'package:book_review/services/book_service.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../widgets/back_button.dart';
import '../widgets/book_detail_card.dart';
import '../widgets/review_card_widget.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final List<ReviewCard> _reviews = [];
  void getBook() async {
    final response = await BookService(widget.book.id ?? 0).getBook();

    if (response['success'] == true) {
      final List reviews = response['data']['book']['reviews'];
      reviews.forEach((review) {
        _reviews.add(ReviewCard(review: Review.fromData(review)));
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getBook();
  }

  @override
  void dispose() {
    _reviews.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Image.asset(constants.logoBanner, width: 240),
        actions: const [
          Padding(
            padding: EdgeInsets.all(6.0),
            child: BackButtonWidget(),
          )
        ],
      ),
      body: ListView(children: [
        BookDetailCardWidget(book: widget.book),
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
              'Değerlendirmeler (${widget.book.reviewCount})',
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
          children: _reviews,
        ),
      ]),
    );
  }
}
