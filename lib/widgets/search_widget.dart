import 'package:book_review/showCustomDialogMixin.dart';
import 'package:book_review/views/search_page.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/consts.dart' as constants;
import '../models/search_data.dart';
import '../services/search_service.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with ShowCustomDialogMixin {
  final searchFormKey = GlobalKey<FormState>();
  final TextEditingController searchTextController = TextEditingController();

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final searchDataProvider = Provider.of<SearchData>(context, listen: false);
    void turnBack() {
      Navigator.pop(context);
    }

    Future<void> goSearch() async {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ));
    }

    Future<void> showErrorMessage() async {
      await showCustomDialog(
          context: context,
          title: 'Hata',
          text: 'Arama sırasında bir hata meydana geldi!');
    }

    Future<void> submitForm() async {
      bool? formIsValid = searchFormKey.currentState?.validate();
      if (formIsValid ?? false) {
        setState(() {
          isSearching = true;
        });
        FocusScope.of(context).unfocus();
        /*Search Service Proc*/
        final response =
            await Search(query: searchTextController.value.text).withQuery();

        if (response['success']) {
          List books = response['data']['data'];
          searchDataProvider.setNextPageUrl(response['data']['next_page_url']);
          searchDataProvider.setPrevPageUrl(response['data']['prev_page_url']);
          searchDataProvider.loadBook(books);
        } else {
          await showErrorMessage();
          turnBack();
        }
        await goSearch();
        turnBack();
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
              Form(
                  key: searchFormKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      enabled: !isSearching,
                      autofocus: true,
                      controller: searchTextController,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: submitForm,
                      validator: (value) {
                        if ((value?.length ?? 0) <
                            constants.minSearchCharLength) {
                          return 'Lütfen en az ${constants.minSearchCharLength} karakter ile arama yapın';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: constants.searchTextHint,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  )),
              SizedBox(
                  child: isSearching ? const LoadingIndicatorWidget() : null)
            ]),
          )
        ],
      ),
    );
  }
}
