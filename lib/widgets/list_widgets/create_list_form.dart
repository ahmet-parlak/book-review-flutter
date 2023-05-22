import 'package:book_review/consts/consts.dart' as constants;
import 'package:flutter/material.dart';

class CreateListFormWidget extends StatelessWidget {
  const CreateListFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchFormKey = GlobalKey<FormState>();
    final TextEditingController textFieldController = TextEditingController();
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, top: 20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Liste Oluştur',
                style: Theme.of(context).textTheme.headlineSmall),
            Divider(
                color: Theme.of(context).primaryColor,
                thickness: 1,
                indent: 20,
                endIndent: 20),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
              width: MediaQuery.of(context).size.width * 0.90,
              child: Form(
                key: searchFormKey,
                child: TextFormField(
                    autofocus: true,
                    controller: textFieldController,
                    decoration: const InputDecoration(
                      hintText: 'Liste Adı',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onEditingComplete: () {
                      bool? formIsValid =
                          searchFormKey.currentState?.validate();
                      if (formIsValid ?? false) {
                        String text = textFieldController.value.text.trim();
                        Navigator.pop(context, text);
                      }
                    },
                    validator: (value) {
                      if ((value?.trim().length ?? 0) <
                          constants.minListNameLength) {
                        return 'Liste adı en az ${constants.minListNameLength} karakterden oluşmalı';
                      } else {
                        return null;
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
