import 'package:book_review/widgets/back_button.dart';
import 'package:book_review/widgets/book_card.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/consts.dart' as constants;
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
    _nextPageUrl = Provider.of<SearchData>(context).getNextPageUrl();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Image.asset(constants.logoBanner, width: 240),
        actions: const [
          Padding(
            padding: EdgeInsets.all(6.0),
            child: BackButtonWidget(),
          )
        ],
        /*actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    context: context,
                    builder: (context) => const SearchWidget());
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            )
          ]*/
      ),
      body: books.isEmpty
          ? const Center(child: Text('Kitap Bulunamadı'))
          : ListView.builder(
              controller: controller,
              itemCount: books.length + 1,
              itemBuilder: (context, index) {
                if (index < books.length) {
                  return BookCardWidget(book: books[index]);
                } else {
                  return _nextPageUrl != null
                      ? const LoadingIndicatorWidget()
                      : null;
                }
              },
            ),
    );
  }
}