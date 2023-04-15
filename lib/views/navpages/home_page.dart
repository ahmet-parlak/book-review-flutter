import 'package:book_review/models/publisher_model.dart';
import 'package:flutter/material.dart';

import '../../models/author_model.dart';
import '../../models/book_model.dart';
import '../../widgets/book_card.dart';
import '../../widgets/menu_card.dart';

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
    //return const Placeholder();
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView(children: [
            BookCardWidget(book: book),
            BookCardWidget(book: book),
            BookCardWidget(book: book),
            BookCardWidget(book: book),
            BookCardWidget(book: book),
          ]),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MenuCardWidget(imageUrl: menu1Url, title: 'Yüksek Puanlılar'),
                MenuCardWidget(imageUrl: menu2Url, title: 'Çok Okunanlar'),
                MenuCardWidget(imageUrl: menu3Url, title: 'Yeni Çıkanlar'),
              ],
            )),
      ],
    );
  }
}
