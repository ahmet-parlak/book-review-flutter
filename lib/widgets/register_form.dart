import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../consts/consts.dart' as constants;
import '../services/register_service.dart';
import 'loading_indicator.dart';

class RegisterFormWidget extends StatefulWidget {
  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool registerBtnIsActive = true;
  Future<void> registerBtnOnPressed() async {
    bool? formIsValid = _loginFormKey.currentState?.validate();

    if (formIsValid ?? false) {
      setState(() {
        registerBtnIsActive = false;
      });
      final register = Register(
        email: _emailController.value.text,
        name: _nameController.value.text,
        password: _passwordController.value.text,
        passwordConfirmation: _passwordConfirmController.value.text,
      );
      final response = await register.register();

      if (response['success']) {
        showCustomDialog(
                title: 'Kayıt Başarılı',
                text: 'E-posta ve şifreniz ile giriş yapabilirsiniz.')
            .then((_) {
          Navigator.pop(context);
        });
      } else {
        final String title = 'Kayıt Yapılamadı';
        String message = '';
        if (response['message'] == 'Validation errors') {}
        message = response['data'].values.join("\n");
        message = message.replaceAll('[', '').replaceAll(']', '');
        showCustomDialog(title: title, text: message);
      }
    }
    setState(() {
      registerBtnIsActive = true;
    });
  }

  Future<void> showCustomDialog(
      {required title, required text, subtext = ''}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(text),
                Text(subtext),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: SingleChildScrollView(
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
                  textInputAction: TextInputAction.next,
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
                  textInputAction: TextInputAction.next,
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
                    if (value!.isEmpty ||
                        value.length < constants.minPasswordLength) {
                      return 'Lütfen en az ${constants.minPasswordLength} karakter uzunluğunda bir şifre girin!';
                    } else {
                      return null;
                    }
                  },
                  textInputAction: TextInputAction.next,
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
                  controller: _passwordConfirmController,
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
              padding: const EdgeInsets.all(50.0),
              child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.14,
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: ElevatedButton(
                      onPressed:
                          registerBtnIsActive ? registerBtnOnPressed : null,
                      child: registerBtnIsActive
                          ? Text(
                              'Kayıt Ol',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            )
                          : const LoadingIndicatorWidget())),
            ),
          ],
        ),
      ),
    );
  }
}
