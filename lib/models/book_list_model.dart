import 'package:book_review/consts/consts.dart' as constants;

class BookList {
  final int? id;
  final String name;
  final String status;
  final String? createDate;

  BookList(
      {this.id,
      required this.name,
      this.status = constants.defaultBookListStatus,
      this.createDate});

  BookList.fromData(data)
      : this.id = data['id'],
        this.name = data['list_name'],
        this.status = data['status'],
        this.createDate = data['created_at'];
}
