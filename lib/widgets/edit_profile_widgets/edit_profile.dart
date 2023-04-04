import 'package:flutter/material.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final Icon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          color: Theme.of(context).primaryColor, shape: StadiumBorder()),
      width: MediaQuery.of(context).size.width * 0.70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          onTap: onTap,
          leading: icon,
          title: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white)),
          iconColor: Colors.white,
        ),
      ),
    );
  }
}
