import 'dart:io';

import 'package:book_review/showCustomDialogMixin.dart';
import 'package:book_review/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart' as constants;
import '../../models/user_data.dart';
import '../../services/edit_profile_service.dart';

class EditProfilePhoto extends StatefulWidget {
  const EditProfilePhoto({Key? key}) : super(key: key);

  @override
  State<EditProfilePhoto> createState() => _EditProfilePhotoState();
}

class _EditProfilePhotoState extends State<EditProfilePhoto>
    with ShowCustomDialogMixin {
  File? _image;
  bool isUpdating = false;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? imgFile = File(image.path);
      final photoFileSize = await imgFile.length();

      if (photoFileSize > constants.maxPhotoFileSize) {
        final sourcePath = imgFile.absolute.path;
        print('*********************************************************');
        print(sourcePath);
        final targetPath = '${sourcePath}.compressed.jpg';
        print(targetPath);
        print('*********************************************************');
        imgFile = await FlutterImageCompress.compressAndGetFile(
          sourcePath,
          targetPath,
          quality: 88,
        );
      }
      setState(() {
        _image = imgFile;
      });
    } catch (e) {
      rethrow;
      showCustomDialog(
          context: context,
          title: 'Hata',
          text: 'Bir hata meydana geldi. Lütfen tekrar deneyin.');
    }
  }

  Future showErrorMessage(Map data) async {
    await showCustomDialog(
      context: context,
      title: 'Hata',
      text: data.values.join('\n'),
    );
  }

  void turnBack(bool? isUpdated) {
    Navigator.pop(context, isUpdated);
  }

  Future<void> update() async {
    setState(() {
      isUpdating = true;
    });
    final response = await EditProfile(
            email:
                Provider.of<UserData>(context, listen: false).user?.email ?? '',
            name:
                Provider.of<UserData>(context, listen: false).user?.name ?? '',
            photoPath: _image?.path)
        .update();
    if (response['success']) {
      turnBack(true);
    } else {
      await showErrorMessage(response['data']);
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.black12,
            radius: 48,
            child: (_image != null)
                ? CircleAvatar(radius: 48, backgroundImage: FileImage(_image!))
                : Text('Fotoğraf Seçin',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black)),
          ),
          const SizedBox(height: 16),
          SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text('Fotoğraf Çek'))),
          SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Galeriden Seç'))),
          const SizedBox(height: 10),
          SizedBox(
              width: 200,
              child: (_image != null)
                  ? ElevatedButton(
                      onPressed: isUpdating ? null : update,
                      child: isUpdating
                          ? const LoadingIndicatorWidget()
                          : const Text('GÜNCELLE'))
                  : null),
        ],
      ),
    );
  }
}
