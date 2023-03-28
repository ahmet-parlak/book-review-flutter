import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'navpages/home_page.dart';
import 'navpages/my_books_page.dart';
import 'navpages/profile_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    getUser();
    //auth();
    super.initState();
  }

  void getUser() async {
    User? user = await Auth().getUser();
    print(user?.name ?? 'Please login!');
  }

  void auth() async {
    var token = await Auth().login(email: 'test@api.com', password: 'password');
    print(token);
  }

  final String logoPath = 'assets/images/logos/BookReview-Banner.png';
  int _navigationBarIndex = 0;
  final _screens = const [HomePage(), MyBooksPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Image.asset(logoPath, width: 260),
        actions: [
          IconButton(
            onPressed: () {},
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

/*
*
*
* */
