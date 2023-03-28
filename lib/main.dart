import 'package:book_review/config/primary_palette.dart';
import 'package:book_review/config/secondary_palette.dart';
import 'package:book_review/views/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookReview',
      theme: ThemeData(
        primaryColor: PrimaryPalette.materialColor,
        primarySwatch: PrimaryPalette.materialColor,
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(secondary: SecondaryPalette.materialColor),
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.transparent),
        elevatedButtonTheme: const ElevatedButtonThemeData(
            style:
                ButtonStyle(shape: MaterialStatePropertyAll(StadiumBorder()))),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: PrimaryPalette.materialColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38),
      ),
      home: const HomeView(),
    );
  }
}
