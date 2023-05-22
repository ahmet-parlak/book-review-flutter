import 'package:book_review/consts/consts.dart' as constants;
import 'package:book_review/consts/sizes.dart' as sizes;
import 'package:flutter/material.dart';

import '../back_button.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppBar({
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Image.asset(constants.logoBanner, width: sizes.appBarBannerWidth),
      actions: const [
        Padding(
          padding: EdgeInsets.all(6.0),
          child: BackButtonWidget(),
        )
      ],
    );
  }
}
