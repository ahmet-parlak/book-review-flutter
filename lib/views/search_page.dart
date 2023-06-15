import 'package:book_review/consts/book_request_consts.dart'
    as bookRequestConsts;
import 'package:book_review/helpers/snackbar_helper.dart';
import 'package:book_review/services/book_request_service.dart';
import 'package:book_review/widgets/appbar/page_app_bar.dart';
import 'package:book_review/widgets/book_card.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../models/search_data.dart';
import '../services/search_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = ScrollController();
  String? _nextPageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        nextPage();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future nextPage() async {
    if (_nextPageUrl != null) {
      final response = await Search(query: '').withUrl(_nextPageUrl!);
      if (response['success']) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          List books = response['data']['data'];
          var searchDataProvider =
              Provider.of<SearchData>(context, listen: false);
          searchDataProvider.setNextPageUrl(response['data']['next_page_url']);
          _nextPageUrl = searchDataProvider.getNextPageUrl();
          searchDataProvider.loadNextPage(books);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = Provider.of<SearchData>(context).getBooks();
    String query = context.watch<SearchData>().query ?? '';
    _nextPageUrl = Provider.of<SearchData>(context).getNextPageUrl();

    return Scaffold(
      appBar: const PageAppBar(),
      body: books.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kitap Bulunamadı',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 12.0),
                  child: const Text(
                      textAlign: TextAlign.center,
                      'ISBN ile aramayı deneyebilir ya da kitabın sisteme eklenmesi için talepte bulunabilirsiniz.'),
                ),
                ElevatedButton(
                    onPressed: () {
                      openDialog();
                    },
                    child: const Text('Kitap İsteği Oluştur')),
              ],
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(bottom: 10.0),
                  child: Text(
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                      'Aradığınız kitaba ulaşmanın en hızlı yolu ISBN (Uluslararası Standart Kitap Numarası) ile arama yapmaktır.'),
                ),
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 4.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '$query',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' için arama sonuçları',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    controller: controller,
                    itemCount: books.length + 1,
                    itemBuilder: (context, index) {
                      if (index < books.length) {
                        return BookCardWidget(book: books[index], index: index);
                      } else {
                        return _nextPageUrl != null
                            ? const LoadingIndicatorWidget()
                            : null;
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => const BookRequestFormDialog(),
      );
}

class BookRequestFormDialog extends StatefulWidget {
  const BookRequestFormDialog({Key? key}) : super(key: key);

  @override
  State<BookRequestFormDialog> createState() => _BookRequestFormDialogState();
}

class _BookRequestFormDialogState extends State<BookRequestFormDialog> {
  final TextEditingController isbnInputController = TextEditingController();
  final TextEditingController titleInputController = TextEditingController();
  final TextEditingController authorInputController = TextEditingController();
  final TextEditingController publisherInputController =
      TextEditingController();
  final _bookRequestFormKey = GlobalKey<FormState>();
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kitap İsteği Oluştur'),
      content: Form(
        key: _bookRequestFormKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 0.0),
              child: TextFormField(
                controller: isbnInputController,
                validator: (value) {
                  //value => input
                  if ((value?.length ?? 0) < bookRequestConsts.isbnMinLength) {
                    return bookRequestConsts.isbnValidationErr;
                  } else {
                    return null;
                  }
                },
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                maxLength: bookRequestConsts.isbnMaxLength,
                decoration: const InputDecoration(hintText: 'ISBN *'),
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: titleInputController,
                validator: (value) {
                  if ((value?.length ?? 1) < bookRequestConsts.titleMinLength) {
                    return bookRequestConsts.titleValidationErr;
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(hintText: 'Kitap Başlığı *'),
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: authorInputController,
                decoration:
                    const InputDecoration(hintText: 'Yazar (opsiyonel)'),
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: publisherInputController,
                decoration:
                    const InputDecoration(hintText: 'Yayınevi (opsiyonel)'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: _isButtonDisabled
                ? null
                : () {
                    Navigator.pop(context);
                  },
            child: const Text('İptal')),
        ElevatedButton(
            onPressed: _isButtonDisabled
                ? null
                : () async {
                    if (_bookRequestFormKey.currentState!.validate()) {
                      setState(() {
                        _isButtonDisabled = true;
                      });
                      final isbn = isbnInputController.value.text;
                      final title = titleInputController.value.text;
                      final author = authorInputController.value.text;
                      final publisher = publisherInputController.value.text;
                      final bookRequestService = BookRequestService(
                          isbn: isbn,
                          title: title,
                          author: author,
                          publisher: publisher);
                      bool isCreated =
                          await bookRequestService.createBookRequest();

                      setState(() {
                        _isButtonDisabled = false;
                      });
                      Navigator.pop(context);

                      if (isCreated) {
                        SnackBarHelper.showSnackBar(
                            context: context,
                            icon: Icons.check,
                            message: 'Talebiniz alındı.');
                      } else {
                        SnackBarHelper.showSnackBar(
                            context: context,
                            message:
                                'Bir hata meydana geldi. Lütfen daha sonra tekar deneyin.');
                      }
                    }
                  },
            child: _isButtonDisabled
                ? const SizedBox(
                    width: 16, height: 16, child: LoadingIndicatorWidget())
                : const Text('İstek Oluştur'))
      ],
    );
  }
}
