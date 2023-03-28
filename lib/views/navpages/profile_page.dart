import 'package:flutter/material.dart';

import '../../widgets/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  final String _imgUrl =
      "https://ui-avatars.com/api/?name=JohnDoe&color=7F9CF5&background=EBF4FF&format=png";

  @override
  Widget build(BuildContext context) {
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
                  radius: 53,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_imgUrl),
                  ),
                ),
                const SizedBox(height: 5),
                Text('John Doe', style: Theme.of(context).textTheme.titleLarge),
                Text('johndoe@app.com',
                    style: Theme.of(context).textTheme.titleMedium),
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
                  shape: StadiumBorder()),
              width: MediaQuery.of(context).size.width * 0.70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.logout_outlined),
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
}
