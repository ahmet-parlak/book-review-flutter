import 'package:book_review/widgets/edit_profile_widgets/edit_name_form.dart';
import 'package:book_review/widgets/edit_profile_widgets/edit_profile_photo.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart' as constants;
import '../../models/user_data.dart';
import '../../showCustomDialogMixin.dart';
import '../../widgets/edit_profile_widgets/edit_email_form.dart';
import '../../widgets/edit_profile_widgets/edit_profile.dart';
import '../../widgets/edit_profile_widgets/reset_password_form.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ShowCustomDialogMixin {
  bool logoutBtnIsActive = true;

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);

    final String userProfileImageUrl = (userData.user?.photoUrl ?? '')
        .replaceAll(constants.localhostDomain, constants.baseUrlDomain);
    final String userEmail = userData.user?.email ?? '';
    final String userName = userData.user?.name ?? '';

    Future<void> showMessageDialog() async {
      await showCustomDialog(
          context: context, title: 'Hata', text: 'Çıkış yapılamadı');
    }

    Future<void> logout() async {
      bool? isLogout =
          await Provider.of<UserData>(context, listen: false).logoutUser();
      if (isLogout == false) {
        showMessageDialog();
      }
    }

    Future<void> logoutBtnOnTap() async {
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

    void getUpdatedUser() {
      Provider.of<UserData>(context, listen: false).getUser();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36.0),
        child: ListView(
          children: [
            //User Profile
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: const AssetImage('assets/gif/loading.gif'),
                  radius: 53,
                  child: GestureDetector(
                    onTap: () async {
                      bool? isUpdated = await showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => const EditProfilePhoto());
                      if (isUpdated == true) {
                        Provider.of<UserData>(context, listen: false).getUser();
                      }
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userProfileImageUrl),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                )))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(userName, style: Theme.of(context).textTheme.titleLarge),
                Text(userEmail, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            //Edit Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  EditProfileWidget(
                      title: 'İsim Düzenle',
                      icon: const Icon(Icons.edit),
                      onTap: () async {
                        bool? isUpdated = await showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) =>
                                EditNameForm(user: userData.user));
                        if (isUpdated ?? false) {
                          getUpdatedUser();
                        }
                      }),
                  const SizedBox(height: 10),
                  EditProfileWidget(
                      title: 'E-posta Değiştir',
                      icon: const Icon(Icons.email),
                      onTap: () async {
                        bool? isUpdated = await showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) =>
                                EditEmailForm(user: userData.user));
                        if (isUpdated ?? false) {
                          getUpdatedUser();
                        }
                      }),
                  const SizedBox(height: 10),
                  EditProfileWidget(
                      title: 'Şifre Güncelle',
                      icon: const Icon(Icons.lock_reset_outlined),
                      onTap: () async {
                        bool? isUpdated = await showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) => const ResetPasswordForm());
                        if (isUpdated ?? false) {
                          showCustomDialog(
                              context: context,
                              title: 'Şifre Güncellendi',
                              text: 'Şifre güncelleme işlemi başarılı!');
                        }
                      }),
                ],
              ),
            ),
            //Logout Button
            Column(
              children: [
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
                      trailing: logoutBtnIsActive
                          ? null
                          : const LoadingIndicatorWidget(),
                      title: Text('Çıkış Yap',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white)),
                      iconColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )
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

/*
* Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                            )))*/
