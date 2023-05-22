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
  final Map<String, Map<String, dynamic>> _values = {
    'title': {'text': 'Başlık', 'value': false},
    'isbn': {'text': 'ISBN', 'value': false},
    'book_photo': {'text': 'Fotoğraf', 'value': false},
    'author': {'text': 'Yazar', 'value': false},
    'publisher': {'text': 'Yayınevi', 'value': false},
    'category': {'text': 'Kategori', 'value': false},
    'publication_year': {'text': 'Yayın Yılı', 'value': false},
    'language': {'text': 'Dil', 'value': false},
    'pages': {'text': 'Sayfa Sayısı', 'value': false},
    'description': {'text': 'Açıklama', 'value': false},
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
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            children:
                _values.keys.map((key) => buildCheckboxListTile(key)).toList()),
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
            if (_values.values.any((innerMap) => innerMap['value'] == true)) {
              final List<String> reportedKeys = _values.keys
                  .where((key) => _values[key]?['value'] == true)
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

  CheckboxListTile buildCheckboxListTile(String key) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(_values[key]!['text'] ?? ''),
      value: _values[key]!['value'],
      onChanged: (bool? value) {
        setState(() {
          _values[key]!['value'] = value;
        });
      },
    );
  }
}
