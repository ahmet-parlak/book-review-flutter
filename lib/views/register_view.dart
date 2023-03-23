import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../widgets/back_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);
  static final _loginFormKey = GlobalKey<FormState>();
  static TextEditingController _nameController = TextEditingController();
  static TextEditingController _emailController = TextEditingController();
  static TextEditingController _passwordController = TextEditingController();
  static TextEditingController _passwordCtrlController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Stack(children: [
            BackButtonWidget(),
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child:
                        Image.asset('assets/images/logos/BookReview-Icon.png')),
                const SizedBox(height: 24),
                Text('KAYIT OL',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                buildLoginForm(context, _loginFormKey)
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Form buildLoginForm(
      BuildContext context, GlobalKey<FormState> _loginFormKey) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Lütfen geçerli bir isim girin!';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2_outlined),
                  hintText: 'İsim',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return 'Lütfen geçerli bir e-posta adresi girin!';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email_outlined),
                  hintText: 'E-posta',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen şifrenizi girin!';
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outlined),
                  hintText: 'Şifre',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: _passwordCtrlController,
                validator: (value) {
                  if (value != _passwordController.value.text) {
                    return 'Şifreler uyuşmuyor!';
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outlined),
                  hintText: 'Şifre Kontrol',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.14,
                width: MediaQuery.of(context).size.width * 0.70,
                child: ElevatedButton(
                    onPressed: () {
                      _loginFormKey.currentState?.validate();
                    },
                    child: Text(
                      'Kayıt Ol',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
          ),
        ],
      ),
    );
  }
}
