import 'package:flutter/material.dart';

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
    return const Placeholder();
    /*return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView(children: [
            BookCardWidget(
                imageUrl: imageUrl,
                title: '1984',
                author: 'George Orwell',
                publisher: 'Can Yayınları',
                rating: '4'),
            BookCardWidget(
                imageUrl: imageUrl,
                title: '1984',
                author: 'George Orwell',
                publisher: 'Can Yayınları',
                rating: '4'),
            BookCardWidget(
                imageUrl: imageUrl,
                title: '1984',
                author: 'George Orwell',
                publisher: 'Can Yayınları',
                rating: '4'),
            BookCardWidget(
                imageUrl: imageUrl,
                title: '1984',
                author: 'George Orwell',
                publisher: 'Can Yayınları',
                rating: '4'),
          ]),
        ),
        Container(
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
    );*/
  }
}
