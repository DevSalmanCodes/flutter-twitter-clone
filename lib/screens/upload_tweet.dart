import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/constants/strings.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/providers/user_provider.dart';
import 'package:twitter/utils/snackbar.dart';

class UploadTweet extends StatefulWidget {
  const UploadTweet({super.key});

  @override
  State<UploadTweet> createState() => _UploadTweetState();
}

class _UploadTweetState extends State<UploadTweet> {
  User? user;
  File? file;
 final TextEditingController _descController = TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  getData() async {
    user = await Provider.of<UserProvider>(context, listen: false)
        .getUser(currentUserUid);
    setState(() {});
  }

  _pickImage() async {
    var pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        file = File(pickedImage.path);
        setState(() {});
      }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            actions: [
              Consumer<TweetProvider>(
                builder: (context, provider, child) => ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(AppColors.whiteColor),
                        backgroundColor: MaterialStateProperty.all(
                            provider.loading
                                ? Colors.blue.shade200
                                : Colors.blue)),
                    onPressed: provider.loading
                        ? null
                        : () async {
                            if (_descController.text.isNotEmpty ||
                                file != null) {
                              await provider
                                  .uploadTweet(_descController.text.trim(),
                                      File(file != null ? file!.path : ''))
                                  .then((value) {
                                CustomSnackBar.success("Posted");
                              });
                            } else {
                              CustomSnackBar.error(
                                  "Please select image or write something!");
                            }
                          },
                    child: const Text("Post")),
              )
            ],
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                ))),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundImage:
                      user?.profilePic != null && user?.profilePic != ''
                          ? Image.network(user!.profilePic).image
                          : Image.network(defaultProfPic).image),
              TextField(
                controller: _descController,
                style: const TextStyle(color: AppColors.whiteColor),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText:
                        file != null ? 'Add a comment' : 'What\'s happening?',
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none)),
              ),
              if (file != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {
                        file = null;
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.whiteColor,
                      )),
                ),
              file != null
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      height: height * 0.5,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.file(
                          fit: BoxFit.cover,
                          File(
                            file!.path,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(height: height * 0.5),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
            child: Container(
          margin: EdgeInsets.only(bottom: keyboardInset),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.image,
                    color: AppColors.whiteColor,
                    size: 30,
                  ))
            ],
          ),
        )));
  }
}
