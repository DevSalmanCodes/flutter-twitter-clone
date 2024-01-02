// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/strings.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/providers/user_provider.dart';
import 'package:twitter/screens/profile.dart';
import 'package:twitter/widgets/custom_text_field.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proivder = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const SizedBox(
            height: 15.0,
          ),
          CustomTextField(
              onFieldSubmitted: (value) {
                setState(() {
                  _searchController.text = value;
                });
              },
              label: "Search",
              hint: 'Search',
              controller: _searchController),
          const SizedBox(
            height: 20.0,
          ),
          _searchController.text.isNotEmpty
              ? FutureBuilder(
                  future: proivder.getSearchUsers(_searchController.text),
                  builder: (context, AsyncSnapshot<List<User>> snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context,int index) {
                                  final user = snapshot.data![index];
                                  return ListTile(
                                    onTap: () =>
                                        Get.to(() => Profile(uid: user.uid)),
                                    leading: CircleAvatar(
                                        backgroundImage: user.profilePic != ''
                                            ? NetworkImage(user.profilePic)
                                            : const NetworkImage(
                                                defaultProfPic)),
                                    title: Text(
                                      user.username,
                                      style: const TextStyle(
                                          color: AppColors.whiteColor),
                                    ),
                                  );
                                })
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
                  })
              : Container()
        ]),
      ),
    );
  }
}
