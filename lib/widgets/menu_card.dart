import 'package:flutter/material.dart';

class MenuCardWidget extends StatelessWidget {
  const MenuCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 70,
              child: Image.network(imageUrl, fit: BoxFit.fill)),
          Text(title)
        ],
      ),
    );
  }
}
