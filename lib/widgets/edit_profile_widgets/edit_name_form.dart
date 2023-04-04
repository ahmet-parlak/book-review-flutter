import 'package:book_review/models/user_model.dart';
import 'package:book_review/showCustomDialogMixin.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_data.dart';
import '../../services/edit_profile_service.dart';

class EditNameForm extends StatefulWidget {
  final User? user;
  const EditNameForm({Key? key, required this.user}) : super(key: key);

  @override
  State<EditNameForm> createState() => _EditNameFormState();
}

class _EditNameFormState extends State<EditNameForm>
    with ShowCustomDialogMixin {
  final editNameFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    nameController.text = widget.user?.name ?? '';
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
        if (nameController.value.text == widget.user?.name) {
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
                name: nameController.value.text)
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
              Text('İsim Düzenle',
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
                      controller: nameController,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: submitForm,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Lütfen geçerli bir isim girin!';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        hintText: 'İsim',
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
