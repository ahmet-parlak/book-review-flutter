import 'package:book_review/services/book_service.dart';
import 'package:flutter/material.dart';

import 'dialogs/custom_alert_dialog.dart';

class BookReportDialogForm extends StatefulWidget {
  final int? bookId;
  const BookReportDialogForm({super.key, required this.bookId});

  @override
  _BookReportDialogFormState createState() => _BookReportDialogFormState();
}

class _BookReportDialogFormState extends State<BookReportDialogForm> {
  final Map<String, bool> _checkedValues = {
    'title': false,
    'isbn': false,
    'book_photo': false,
    'author': false,
    'publisher': false,
    'category': false,
    'publication_year': false,
    'language': false,
    'pages': false,
    'description': false,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> successDialog(
        {required String message, String title = 'Başarılı'}) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            message: message,
            title: title,
          );
        },
      );
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Hatalı ya da eksik olduğunu düşündüğünüz bilgileri işaretleyin.',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Başlık'),
            value: _checkedValues['title'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['title'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('ISBN'),
            value: _checkedValues['isbn'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['isbn'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Fotoğraf'),
            value: _checkedValues['book_photo'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['book_photo'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Yazar'),
            value: _checkedValues['author'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['author'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Yayınevi'),
            value: _checkedValues['publisher'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['publisher'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Kategori'),
            value: _checkedValues['category'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['category'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Yayın Yılı'),
            value: _checkedValues['publication_year'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['publication_year'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Dil'),
            value: _checkedValues['language'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['language'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Sayfa Sayısı'),
            value: _checkedValues['pages'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['pages'] = value!;
              });
            },
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Açıklama'),
            value: _checkedValues['description'],
            onChanged: (bool? value) {
              setState(() {
                _checkedValues['description'] = value!;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('İptal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Raporla'),
          onPressed: () async {
            if (_checkedValues.containsValue(true)) {
              final List<String> reportedKeys = _checkedValues.keys
                  .where((key) => _checkedValues[key] == true)
                  .toList();
              final response =
                  await BookService(widget.bookId).reportBook(reportedKeys);
              if (response['success'] == true) {
                await successDialog(
                    title: response['data']['title'],
                    message: response['data']['message']);
                Navigator.of(context).pop();
              }
            } else {
              await successDialog(
                  title: 'Dikkat',
                  message:
                      'Lütfen rapor etmek istediğiniz verileri işaretleyin!');
            }
          },
        ),
      ],
    );
  }
}
