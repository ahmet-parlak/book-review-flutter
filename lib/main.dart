import 'package:book_review/config/primary_palette.dart';
import 'package:book_review/config/secondary_palette.dart';
import 'package:book_review/views/home_view.dart';
import 'package:book_review/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/search_data.dart';
import 'models/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserData().getUser();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserData>(create: (_) => UserData()),
      ChangeNotifierProvider<SearchData>(create: (_) => SearchData())
    ],
    child: const MyApp(),
  ));
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
        colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: PrimaryPalette.materialColor,
            secondary: SecondaryPalette.materialColor),
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.transparent),
        elevatedButtonTheme: const ElevatedButtonThemeData(
            style:
                ButtonStyle(shape: MaterialStatePropertyAll(StadiumBorder()))),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: PrimaryPalette.materialColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38),
      ),
      home: Provider.of<UserData>(context).user == null
          ? const LoginView()
          : const HomeView(),
    );
  }
}
