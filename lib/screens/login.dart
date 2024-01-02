// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:twitter/providers/auth_provider.dart';
import 'package:twitter/screens/sign_up.dart';
import 'package:twitter/utils/snackbar.dart';

import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../widgets/custom_text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/icons/logo.svg',  color: Colors.white,
          height: 25,),
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
                login,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor),
              ),
            ),
            SizedBox(
              height: height * 0.03,
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
                        ? Get.to(() => const SignUp())
                        : null,
                    child: const Text(
                      'Sign Up',
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
                            if (emailController.text.isEmpty ||
                                emailController.text == null ||
                                passwordController.text.isEmpty ||
                                passwordController.text == null) {
                              CustomSnackBar.error(
                                  "Please provide required information");
                            } else {
                              provider.login(emailController.text,
                                  passwordController.text);
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
