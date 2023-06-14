import 'package:book_review/views/navpages/mybooks/my_lists.dart';
import 'package:book_review/views/navpages/mybooks/my_reviews.dart';
import 'package:flutter/material.dart';

class MyBooksPage extends StatelessWidget {
  const MyBooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: ShapeDecoration(
                      color: Colors.grey[300], shape: const StadiumBorder()),
                  child: TabBar(
                    indicator: ShapeDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: const StadiumBorder()),
                    labelColor: Colors.white,
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    tabs: const [
                      Tab(text: 'Listelerim'),
                      Tab(text: 'Değerlendirmelerim')
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Center(child: MyLists()),
                      Center(child: MyReviews()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
