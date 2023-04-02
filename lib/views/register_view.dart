import 'package:flutter/material.dart';

import '../widgets/back_button.dart';
import '../widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(children: [
              BackButtonWidget(),
              Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Image.asset(
                          'assets/images/logos/BookReview-Icon.png')),
                  const SizedBox(height: 24),
                  Text('KAYIT OL',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  RegisterFormWidget(),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
