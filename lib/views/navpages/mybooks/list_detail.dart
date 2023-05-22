import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/helpers/snackbar_helper.dart';
import 'package:book_review/models/book_list_model.dart';
import 'package:book_review/models/book_model.dart';
import 'package:book_review/models/my_lists_data.dart';
import 'package:book_review/views/book_detail_page.dart';
import 'package:book_review/widgets/appbar/page_app_bar.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../extensions/string_extension.dart';
import '../../../models/book_list_data.dart';

class ListDetail extends StatelessWidget {
  const ListDetail({Key? key, required this.bookList}) : super(key: key);
  final BookList bookList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListData>(
      create: (context) => BookListData(bookList),
      child: const ListDetailScaffold(),
    );
  }
}

class ListDetailScaffold extends StatelessWidget {
  const ListDetailScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = context.watch<BookListData>().list;
    return Scaffold(
      appBar: const PageAppBar(),
      body: ListView(children: [
        ListName(list: list),
        const SizedBox(height: 5.0),
        ListSettings(list: list),
        const ListBooks()
      ]),
    );
  }
}

class ListName extends StatefulWidget {
  const ListName({
    super.key,
    required this.list,
  });

  final BookList list;

  @override
  State<ListName> createState() => _ListNameState();
}

class _ListNameState extends State<ListName> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textFieldcontroller;
  late final FocusNode _focusNode;
  bool isListNameUpdating = false;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _textFieldcontroller = TextEditingController(
        text: (constants.defaultBookLists[widget.list.name] ?? widget.list.name)
            .capitalize());
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final isDefaultList =
        constants.defaultBookLists[widget.list.name] == null ? false : true;

    isChangedAction(isChanged) {
      if (isChanged) {
        context.read<MyListsData>().fetchLists();
      } else {
        _textFieldcontroller.text = widget.list.name.capitalize();
        SnackBarHelper.showSnackBar(
            context: context, message: 'Bu isimde bir listeniz zaten mevcut.');
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isDefaultList
            ? Container(
                width: MediaQuery.of(context).size.width * 0.96,
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  (constants.defaultBookLists[widget.list.name] ??
                          widget.list.name)
                      .capitalize(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              )
            : GestureDetector(
                onTap: () {
                  _focusNode.requestFocus();
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Form(
                          key: _formKey,
                          child: isListNameUpdating
                              ? const LoadingIndicatorWidget()
                              : TextFormField(
                                  controller: _textFieldcontroller,
                                  focusNode: _focusNode,
                                  textAlign: TextAlign.center,
                                  validator: (value) {
                                    if ((value?.trim().length ?? 0) <
                                        constants.minListNameLength) {
                                      return 'Minimum ${constants.minListNameLength} karakter girilmelidir.';
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () async {
                                    final listName =
                                        widget.list.name.toLowerCase();
                                    final newListName = _textFieldcontroller
                                        .value.text
                                        .trim()
                                        .toLowerCase();
                                    if (listName == newListName) {
                                      _focusNode.unfocus();
                                    } else {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _focusNode.unfocus();
                                        setState(() {
                                          isListNameUpdating = true;
                                        });
                                        bool isChanged = await context
                                            .read<BookListData>()
                                            .changeName(newListName);
                                        isChangedAction(isChanged);
                                        setState(() {
                                          isListNameUpdating = false;
                                        });
                                      }
                                    }
                                  },
                                  onTapOutside: (event) {
                                    _textFieldcontroller.text =
                                        (constants.defaultBookLists[
                                                    widget.list.name] ??
                                                widget.list.name)
                                            .capitalize();
                                    _formKey.currentState?.validate();
                                    _focusNode.unfocus();
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                        )),
                    const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
      ],
    );
  }
}

class ListSettings extends StatelessWidget {
  const ListSettings({
    super.key,
    required this.list,
  });

  final BookList list;

  @override
  Widget build(BuildContext context) {
    final isDefaultList =
        constants.defaultBookLists[list.name] == null ? false : true;

    listRemoved() {
      context.read<MyListsData>().removeList(list.id);
      Navigator.pop(context);
    }

    confirmButtonIsDeletedAction(bool isDeleted) {
      if (isDeleted) {
        Navigator.pop(context, true);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: isDefaultList
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      context.watch<BookListData>().isPrivate != null
                          ? Switch(
                              value: !context.watch<BookListData>().isPrivate!,
                              onChanged: (value) async {
                                await context
                                    .read<BookListData>()
                                    .toggleListStatus();
                              },
                            )
                          : Container(
                              width: 32,
                              height: 32,
                              padding: const EdgeInsets.all(8.0),
                              child: const LoadingIndicatorWidget()),
                      Text(
                        constants.bookListsStatus[list.status] ?? "-",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const Text('Liste Görünürülüğü'),
                ],
              ),
              isDefaultList
                  ? const SizedBox()
                  : Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              Widget cancelButton = TextButton(
                                child: const Text("İptal"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                              Widget confirmButton = TextButton(
                                child: const Text("Onayla"),
                                onPressed: () async {
                                  final bool isDeleted = await context
                                      .read<BookListData>()
                                      .deleteList();
                                  confirmButtonIsDeletedAction(isDeleted);
                                },
                              );
                              AlertDialog alert = AlertDialog(
                                title: const Text("Dikkat!"),
                                content: const Text(
                                    "Liste ve listede bulunan kitaplar kaldırılacak. Bu işlem geri alınamaz."),
                                actions: [
                                  cancelButton,
                                  confirmButton,
                                ],
                              );
                              final bool? isDeleted = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );

                              if (isDeleted ?? false) {
                                listRemoved();
                              }
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              size: 28,
                              color: Colors.red,
                            )),
                        const Text('Listeyi Sil'),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class ListBooks extends StatelessWidget {
  const ListBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BookListData>().books;
    final isFetchingBooks = context.watch<BookListData>().isFetchingBooks;

    isRemovedAction(bool isRemoved) {
      if (isRemoved) {
        context.read<MyListsData>().fetchLists();
        SnackBarHelper.showSnackBar(
            context: context,
            message: 'Kitap listeden kaldırıldı',
            icon: Icons.check_circle);
      } else {
        SnackBarHelper.showSnackBar(
            context: context,
            message:
                'Kitap listeden kaldırıldırılırken bir hata meydana geldi');
      }
    }

    return isFetchingBooks
        ? const LoadingIndicatorWidget()
        : books.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Listeye Henüz Kitap Ekelemediniz',
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('Kitabı listeden kaldırmak için kaydırın'),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.all(6.0),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            background: Container(
                                color: Colors.red,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(Icons.delete_forever,
                                        color: Colors.white, size: 36),
                                  ),
                                )),
                            secondaryBackground: Container(
                                color: Colors.red,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.delete_forever,
                                        color: Colors.white, size: 36),
                                  ),
                                )),
                            onDismissed: (direction) async {
                              Book book = books[index];
                              bool isRemoved = await context
                                  .read<BookListData>()
                                  .removeBook(book: book.id);

                              isRemovedAction(isRemoved);
                            },
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookDetailPage(book: book),
                                      ));
                                },
                                title: Row(
                                  children: [
                                    SizedBox(
                                        height: 84,
                                        width: 60,
                                        child: Image.network(
                                          book.photo ?? '',
                                          fit: BoxFit.fitHeight,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }

                                            return const Center(
                                                child:
                                                    LoadingIndicatorWidget());
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(constants
                                                      .bookCoverNotAvailable),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  book.title ?? '-',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  book.author?.name ?? '-',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.fade,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  book.publisher?.name ?? '-',
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: book.rating
                                                            ?.toDouble() ??
                                                        0,
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    ignoreGestures: true,
                                                    itemCount: 5,
                                                    itemSize: 14,
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '(${book.reviewCount ?? ''})',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
  }
}
