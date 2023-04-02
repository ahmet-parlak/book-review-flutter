import 'package:book_review/views/register_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';
import '../widgets/loading_indicator.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static final _loginFormKey = GlobalKey<FormState>();
  static TextEditingController _emailController = TextEditingController();
  static TextEditingController _passwordController = TextEditingController();

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final String logoPath = 'assets/images/logos/BookReview-Icon.png';

  bool loginBtnIsActive = true;
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Giriş Yapılamadı'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('E-posta ya da şifre yanlış!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loginOnPressed() async {
    if (LoginView._loginFormKey.currentState?.validate() ?? false) {
      setState(() {
        loginBtnIsActive = false;
      });

      bool? isLogin = await Provider.of<UserData>(context, listen: false)
          .loginUser(
              email: LoginView._emailController.value.text,
              password: LoginView._passwordController.value.text);

      if (isLogin == false) {
        _showMyDialog();
        setState(() {
          loginBtnIsActive = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Image.asset(logoPath)),
              SizedBox(height: 24),
              Text('GİRİŞ YAP',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              buildLoginForm(context, LoginView._loginFormKey)
            ],
          ),
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
                controller: LoginView._emailController,
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
                controller: LoginView._passwordController,
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
          TextButton(onPressed: () {}, child: Text('Şifremi Unuttum')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.14,
              width: MediaQuery.of(context).size.width * 0.70,
              child: ElevatedButton(
                onPressed: loginBtnIsActive ? loginOnPressed : null,
                child: loginBtnIsActive
                    ? Text(
                        'Giriş Yap',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      )
                    : LoadingIndicatorWidget(),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterView()));
              },
              child: Text('Kayıt Ol')),
        ],
      ),
    );
  }
}
