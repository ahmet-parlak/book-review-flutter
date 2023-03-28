import 'package:flutter/material.dart';

class BookCardWidget extends StatelessWidget {
  const BookCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.publisher,
    required this.rating,
  });

  final String imageUrl;
  final String title;
  final String author;
  final String publisher;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Row(
        children: [
          SizedBox(
              height: 140, child: Image.network(imageUrl, fit: BoxFit.fill)),
          Expanded(
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.black),
                ),
                Text(author, style: Theme.of(context).textTheme.titleLarge),
                Text(publisher, style: Theme.of(context).textTheme.titleLarge),
                Text(rating),
              ],
            ),
          )
        ],
      ),
    );
  }
}
