// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/strings.dart';
import 'package:twitter/providers/auth_provider.dart';
import 'package:twitter/screens/login.dart';
import 'package:twitter/utils/snackbar.dart';
import 'package:twitter/widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  File? file;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    super.dispose();
  }

  pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/icons/logo.svg',
          color: Colors.white,
          height: 25,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 12.0,
            ),
            const Center(
              child: Text(
                createAccount,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: file != null
                      ? Image.file(file!).image
                      : const NetworkImage(defaultProfPic),
                ),
                Positioned(
                    bottom: -10,
                    left: 50,
                    child: IconButton(
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 25,
                        )))
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            CustomTextField(
              controller: nameController,
              hint: name,
              label: name,
              maxLength: 50,
            ),
            CustomTextField(
              controller: emailController,
              hint: email,
              label: email,
            ),
            const SizedBox(
              height: 12.0,
            ),
            CustomTextField(
              controller: passwordController,
              hint: password,
              label: password,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => !authProvider.loading
                        ? Get.to(() => const Login())
                        : null,
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    )),
                Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: Consumer<AuthProvider>(
                      builder: (context, provider, child) => ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  provider.loading
                                      ? AppColors.greyColor
                                      : AppColors.whiteColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))),
                          onPressed: () {
                            if (nameController.text.isEmpty ||
                                nameController.text == null ||
                                emailController.text.isEmpty ||
                                emailController.text == null ||
                                passwordController.text.isEmpty ||
                                passwordController.text == null) {
                              CustomSnackBar.error(
                                  "Please provide required information");
                            } else {
                              authProvider.signUp(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  nameController.text.trim(),
                                  bioController.text.trim(),
                                  File(file != null ? file!.path : ''));
                            }
                          },
                          child: const Text(
                            next,
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.bold),
                          )),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
