import 'package:book_review/consts/sizes.dart' as sizes;
import 'package:book_review/widgets/search_widget.dart';
import 'package:flutter/material.dart';

import 'navpages/home_page.dart';
import 'navpages/my_books_page.dart';
import 'navpages/profile_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String logoPath = 'assets/images/logos/BookReview-Banner.png';
  int _navigationBarIndex = 0;
  final _screens = const [HomePage(), MyBooksPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Image.asset(logoPath, width: sizes.appBarBannerWidth),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (context) => const SearchWidget());
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          )
        ],
      ),
      body: _screens[_navigationBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), label: 'Kitaplarım'),
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined), label: 'Profil')
        ],
        currentIndex: _navigationBarIndex,
        onTap: (value) {
          setState(() {
            _navigationBarIndex = value;
          });
        },
      ),
    );
  }
}
