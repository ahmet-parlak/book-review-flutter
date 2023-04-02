import 'package:book_review/views/home_view.dart';
import 'package:book_review/views/login_view.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import '../models/user_data.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/images/logos/BookReview-Banner.png'),
      title: const Text(
        "",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      loaderColor: Theme.of(context).primaryColor,
      loadingText: const Text(
        "Yükleniyor...",
        //style: TextStyle(color: Colors.blue[600]),
      ),
      navigator: UserData().user == null ? const LoginView() : const HomeView(),
      durationInSeconds: 4,
    );
  }
}
