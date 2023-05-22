import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/models/my_lists_data.dart';
import 'package:book_review/views/navpages/mybooks/list_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../extensions/string_extension.dart';

class MyLists extends StatelessWidget {
  const MyLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<MyListsData>().bookLists;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) => Card(
          elevation: 2.4,
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ListDetail(bookList: lists[index])));
            },
            title: Text((constants.defaultBookLists[lists[index].name] ??
                    lists[index].name)
                .capitalize()),
            trailing: Text("${lists[index].bookCount ?? '-'}"),
          ),
        ),
      ),
    );
  }
}
