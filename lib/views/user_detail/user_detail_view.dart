import 'package:book_review/models/user_detail_data.dart';
import 'package:book_review/models/user_model.dart';
import 'package:book_review/views/user_detail/user_detail_lists.dart';
import 'package:book_review/views/user_detail/user_reviews.dart';
import 'package:book_review/widgets/appbar/page_app_bar.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailView extends StatefulWidget {
  const UserDetailView({Key? key, required this.user}) : super(key: key);
  final User? user;
  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  bool isLoading = false;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  Future fetchUserData() async {
    //isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    User? user = widget.user;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDetailData>(
          create: (context) => UserDetailData(user),
        ),
      ],
      child: Scaffold(
        appBar: const PageAppBar(),
        body: isLoading
            ? const LoadingIndicatorWidget()
            : Center(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user?.photoUrl ?? ''),
                      ),
                      Text(user?.name ?? '',
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 5),
                      Container(
                        height: 45,
                        decoration: ShapeDecoration(
                            color: Colors.grey[300],
                            shape: const StadiumBorder()),
                        child: TabBar(
                          indicator: ShapeDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: const StadiumBorder()),
                          labelColor: Colors.white,
                          unselectedLabelColor: Theme.of(context).primaryColor,
                          tabs: const [
                            Tab(text: 'Listeler'),
                            Tab(text: 'Değerlendirmeler')
                          ],
                        ),
                      ),
                      const Expanded(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Center(child: UserLists() /*MyLists()*/),
                            Center(child: UserReviews() /*MyReviews()*/),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
