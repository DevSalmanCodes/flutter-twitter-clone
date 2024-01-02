import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/providers/user_provider.dart';
import 'package:twitter/widgets/custom_text_field.dart';
import 'package:twitter/utils/snackbar.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? file;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  User? user;
  pickImage(ImageSource source) async {
    var pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (_nameController.text != user?.username ||
                    _bioController.text != user?.bio ||
                    file != null) {
                  context
                      .read<UserProvider>()
                      .updateProfile(File(file != null ? file!.path : ''),
                          _nameController.text, _bioController.text);
                    
                        CustomSnackBar.success("Saved");
                        Get.back();
                } else {
                  Get.back();
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(
                    color: AppColors.whiteColor, fontWeight: FontWeight.bold),
              ))
        ],
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
        title: const Text(
          "Edit profile",
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: provider.getUser(currentUserUid),
            builder: (context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                _nameController.text = data!.username;
                _bioController.text = data.bio;

                user = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                              radius: 35,
                              backgroundImage: file != null
                                  ? Image.file(File(file!.path)).image
                                  : NetworkImage(
                                      data.profilePic,
                                    )),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  file = await pickImage(ImageSource.gallery);
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.image,
                                  color: AppColors.whiteColor,
                                  size: 25,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      CustomTextField(
                          label: 'Name',
                          hint: 'Name',
                          controller: _nameController),
                      const SizedBox(
                        height: 15.0,
                      ),
                      CustomTextField(
                          label: 'Bio',
                          hint: 'Bio',
                          controller: _bioController),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
