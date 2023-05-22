import 'package:book_review/widgets/appbar/page_app_bar.dart';
import 'package:book_review/widgets/book_card.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
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
    _nextPageUrl = Provider.of<SearchData>(context).getNextPageUrl();
    return Scaffold(
      appBar: const PageAppBar(),
      body: books.isEmpty
          ? const Center(child: Text('Kitap Bulunamadı'))
          : GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

/*ListView.builder(
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
            )*/
