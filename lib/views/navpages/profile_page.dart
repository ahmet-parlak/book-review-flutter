import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart' as constants;
import '../../models/user_data.dart';
import '../../widgets/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool logoutBtnIsActive = true;

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);

    final String userProfileImageUrl = (userData.user?.photoUrl ?? '')
        .replaceAll(constants.localhostDomain, constants.baseUrlDomain);
    final String userEmail = userData.user?.email ?? '';
    final String userName = userData.user?.name ?? '';

    Future<void> showCustomDialog(
        {required title, required text, subtext = ''}) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(text),
                  Text(subtext),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    logout() async {
      bool? isLogout =
          await Provider.of<UserData>(context, listen: false).logoutUser();
      if (isLogout == false) {
        showCustomDialog(title: 'Hata', text: 'Çıkış yapılamadı');
      }
    }

    logoutBtnOnTap() async {
      bool? logoutAccepted = await _showLogoutDialog(context);
      if (logoutAccepted == true) {
        setState(() {
          logoutBtnIsActive = false;
        });
        await logout();
        setState(() {
          logoutBtnIsActive = true;
        });
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: const AssetImage('assets/gif/loading.gif'),
                  radius: 53,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userProfileImageUrl),
                  ),
                ),
                const SizedBox(height: 5),
                Text(userName, style: Theme.of(context).textTheme.titleLarge),
                Text(userEmail, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            Column(
              children: const [
                EditProfileWidget(
                    title: 'İsim Düzenle', icon: Icon(Icons.edit)),
                SizedBox(height: 10),
                EditProfileWidget(
                    title: 'E-posta Değiştir', icon: Icon(Icons.email)),
                SizedBox(height: 10),
                EditProfileWidget(
                    title: 'Şifre Güncelle',
                    icon: Icon(Icons.lock_reset_outlined)),
              ],
            ),
            Container(
              decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: const StadiumBorder()),
              width: MediaQuery.of(context).size.width * 0.70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  onTap: logoutBtnIsActive
                      ? logoutBtnOnTap
                      : () {
                          deactivate();
                        },
                  leading: const Icon(Icons.logout_outlined),
                  trailing:
                      logoutBtnIsActive ? null : const LoadingIndicatorWidget(),
                  title: Text('Çıkış',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white)),
                  iconColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Çıkış Yap'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Çıkış yapmak istediğinize emin misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }
}
