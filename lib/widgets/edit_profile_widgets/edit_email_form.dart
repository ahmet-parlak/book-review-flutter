import 'package:book_review/models/user_model.dart';
import 'package:book_review/showCustomDialogMixin.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_data.dart';
import '../../services/edit_profile_service.dart';

class EditEmailForm extends StatefulWidget {
  final User? user;
  const EditEmailForm({Key? key, required this.user}) : super(key: key);

  @override
  State<EditEmailForm> createState() => _EditEmailFormState();
}

class _EditEmailFormState extends State<EditEmailForm>
    with ShowCustomDialogMixin {
  final editNameFormKey = GlobalKey<FormState>();
  final TextEditingController emailTextController = TextEditingController();
  @override
  void initState() {
    emailTextController.text = widget.user?.email ?? '';
    // TODO: implement initState
    super.initState();
  }

  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    void turnBack(bool? isUpdated) {
      Navigator.pop(context, isUpdated);
    }

    Future<void> showErrorMessage() async {
      await showCustomDialog(
          context: context,
          title: 'Hata',
          text: 'Güncelleme sırasında bir hata meydana geldi!');
    }

    Future<void> submitForm() async {
      bool? formIsValid = editNameFormKey.currentState?.validate();
      if (formIsValid ?? false) {
        if (emailTextController.value.text == widget.user?.email) {
          turnBack(false);
          return;
        }
        setState(() {
          isUpdating = true;
        });
        FocusScope.of(context).unfocus();
        final response = await EditProfile(
                email:
                    Provider.of<UserData>(context, listen: false).user?.email ??
                        '',
                name: emailTextController.value.text)
            .update();
        if (response['success']) {
          turnBack(true);
        } else {
          await showErrorMessage();
          turnBack(false);
        }
      }
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            child: Column(children: [
              Text('E-Posta Güncelle',
                  style: Theme.of(context).textTheme.titleLarge),
              Divider(
                  height: 20,
                  color: Theme.of(context).primaryColor,
                  thickness: 1),
              Form(
                  key: editNameFormKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      autofocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailTextController,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: submitForm,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  )),
              SizedBox(
                  child: isUpdating ? const LoadingIndicatorWidget() : null)
            ]),
          )
        ],
      ),
    );
  }
}
