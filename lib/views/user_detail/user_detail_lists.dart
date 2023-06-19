import 'package:book_review/extensions/string_extension.dart';
import 'package:book_review/models/user_detail_data.dart';
import 'package:book_review/views/user_detail/user_list_detail.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart' as constants;

class UserLists extends StatefulWidget {
  const UserLists({Key? key}) : super(key: key);

  @override
  State<UserLists> createState() => _UserListsState();
}

class _UserListsState extends State<UserLists> {
  @override
  Widget build(BuildContext context) {
    final lists = context.watch<UserDetailData>().userLists;
    final isUserListExists = context.watch<UserDetailData>().isUserListExist;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: lists.isNotEmpty
          ? ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) => Card(
                elevation: 2.4,
                child: ListTile(
                  onTap: () {
                    final user = context.read<UserDetailData>().user;
                    if (user == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserListDetail(
                                user: user,
                                list: lists[index],
                              )),
                    );
                  },
                  title: Text((constants.defaultBookLists[lists[index].name] ??
                          lists[index].name)
                      .capitalize()),
                  trailing: Text("${lists[index].bookCount ?? '-'}"),
                ),
              ),
            )
          : isUserListExists
              ? const LoadingIndicatorWidget()
              : const Text('Kullanıcının Herkese Açık Listesi Bulunamadı'),
    );
  }
}
