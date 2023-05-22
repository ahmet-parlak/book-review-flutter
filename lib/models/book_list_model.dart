import 'package:book_review/consts/consts.dart' as constants;

class BookList {
  final int? id;
  final String name;
  final String status;
  final String? createDate;
  int? bookCount;

  BookList(
      {this.id,
      required this.name,
      this.status = constants.defaultBookListStatus,
      this.createDate,
      this.bookCount});

  BookList.fromData(data)
      : this.id = data['id'],
        this.name = data['list_name'],
        this.status = data['status'],
        this.bookCount = data['books_count'],
        this.createDate = data['created_at'];
}
