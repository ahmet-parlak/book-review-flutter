import 'package:book_review/models/home_data.dart';
import 'package:book_review/models/publisher_model.dart';
import 'package:book_review/widgets/book_card.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/author_model.dart';
import '../../models/book_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String imageUrl =
      'https://images.isbndb.com/covers/85/33/9789750718533.jpg';

  final String menu1Url =
      'https://media.istockphoto.com/vectors/heart-shaped-book-shelf-with-colorful-books-heart-of-knowledge-vector-id475120264?k=20&m=475120264&s=170667a&w=0&h=nfBQ_-hqt6WB-5eWKW6xcyDuw8AIklQbd5SSm1VIgfc=';

  final String menu2Url =
      'https://i.cnnturk.com/i/cnnturk/75/0x555/53e4aa14f630990824a48f81';

  final String menu3Url = 'https://images7.alphacoders.com/451/451791.jpg';

  @override
  Widget build(BuildContext context) {
    final book = Book(
        photo: imageUrl,
        title: '1984',
        author: Author(name: 'George Orwell'),
        publisher: Publisher(name: 'Can Yayınları'),
        rating: 4,
        reviewCount: 14);

    /*return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trend Kitaplar',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
            ...[
              BookCardWidget(book: book),
              BookCardWidget(book: book),
              BookCardWidget(book: book),
              BookCardWidget(book: book),
              BookCardWidget(book: book),
            ]
          ],
        ),
      ],
    );*/
    return ChangeNotifierProvider<HomeData>(
      create: (context) => HomeData(),
      child: HomeGrid(book: book),
    );
  }
}

class HomeGrid extends StatefulWidget {
  const HomeGrid({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  @override
  Widget build(BuildContext context) {
    final homeData = context.watch<HomeData>().homeData;
    /*return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      children: [
        ...[
          BookCardWidget(book: homeData[0]['books'][0]),
          BookCardWidget(book: book),
          BookCardWidget(book: book),
          BookCardWidget(book: book),
          BookCardWidget(book: book),
        ],
      ],
    );*/

    return homeData.length == 0
        ? LoadingIndicatorWidget()
        : ListView(
            physics: const BouncingScrollPhysics(),
            children: homeData.map((section) {
              List books = section['books'];
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(section['title'],
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children:
                      books.map((book) => BookCardWidget(book: book)).toList(),
                )
              ]);
            }).toList(),
          );
  }
}
