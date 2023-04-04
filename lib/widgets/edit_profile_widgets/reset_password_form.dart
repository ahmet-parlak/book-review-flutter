import 'package:book_review/showCustomDialogMixin.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

import '../../consts/consts.dart' as constants;
import '../../services/reset_password_service.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm>
    with ShowCustomDialogMixin {
  final resetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    void turnBack(bool? isUpdated) {
      Navigator.pop(context, isUpdated);
    }

    Future<void> showErrorMessage(Map data) async {
      await showCustomDialog(
          context: context, title: 'Hata', text: data.values.join('\n'));
    }

    Future<void> submitForm() async {
      bool? formIsValid = resetPasswordFormKey.currentState?.validate();
      if (formIsValid ?? false) {
        setState(() {
          isUpdating = true;
        });
        FocusScope.of(context).unfocus();
        final response = await ResetPassword(
                currentPassword: currentPasswordController.value.text,
                newPassword: newPasswordController.value.text,
                passwordConfirmation: confirmPasswordController.value.text)
            .reset();
        if (response['success']) {
          turnBack(true);
        } else {
          await showErrorMessage(response['data']);
          setState(() {
            isUpdating = false;
          });
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                  child: Column(children: [
                    Text('Şifre Güncelle',
                        style: Theme.of(context).textTheme.titleLarge),
                    Divider(
                        height: 20,
                        color: Theme.of(context).primaryColor,
                        thickness: 1),
                    Form(
                        key: resetPasswordFormKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Column(
                            children: [
                              TextFormField(
                                autofocus: true,
                                controller: currentPasswordController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return 'Lütfen mevcut şifrenizi girin!';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  hintText: 'Mevcut Şifreniz',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                autofocus: true,
                                controller: newPasswordController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if ((value?.length ?? 0) <
                                      constants.minPasswordLength) {
                                    return 'Şifreniz en az ${constants.minPasswordLength} karakter uzunluğunda olmalı!';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_reset_outlined),
                                  hintText: 'Yeni Şifreniz',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                autofocus: true,
                                controller: confirmPasswordController,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: submitForm,
                                validator: (value) {
                                  if (value !=
                                      newPasswordController.value.text) {
                                    return 'Şifreler eşleşmiyor!';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_reset_outlined),
                                  hintText: 'Şifre Kontrol',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: isUpdating ? null : submitForm,
                                  child: const Text('GÜNCELLE'))
                            ],
                          ),
                        )),
                    SizedBox(
                        child:
                            isUpdating ? const LoadingIndicatorWidget() : null)
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
