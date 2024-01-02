// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/constants/strings.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/providers/auth_provider.dart';
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/providers/user_provider.dart';
import 'package:twitter/screens/profile.dart';
import 'package:twitter/screens/upload_tweet.dart';
import 'package:twitter/widgets/drawer_tile.dart';
import 'package:twitter/widgets/feed_card.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  User? user;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    if (mounted) {
      user = await Provider.of<UserProvider>(context, listen: false)
          .getUser(auth.currentUser!.uid);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: AppColors.blackColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          user?.profilePic != null && user?.profilePic != ''
                              ? user!.profilePic
                              : defaultProfPic)),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    user?.username != null ? user!.username : 'username',
                    style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            user?.following != null
                                ? user!.following.length.toString()
                                : '0',
                            style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Text(
                            "Following",
                            style: TextStyle(color: AppColors.greyColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Row(
                        children: [
                          Text(
                            user?.followers != null
                                ? user!.followers.length.toString()
                                : '0',
                            style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "Followers",
                            style: TextStyle(color: AppColors.greyColor),
                          )
                        ],
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade900,
                  ),
                  DrawerTile(
                      onTap: () => Get.to(() => Profile(
                            uid: currentUserUid,
                          )),
                      icon: 'assets/icons/profile.svg',
                      title: 'Profile'),
                  const DrawerTile(
                      icon: 'assets/icons/lists.svg', title: 'Lists'),
                  const DrawerTile(
                      icon: 'assets/icons/topics.svg', title: 'Topics'),
                  const DrawerTile(
                      icon: 'assets/icons/bookmarks.svg', title: 'Bookmarks'),
                  const DrawerTile(
                      icon: 'assets/icons/moments.svg', title: 'Moments'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    color: Colors.grey.shade900,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Settings and privacy',
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                context.read<AuthProvider>().logOut();
              },
              child: SvgPicture.asset(
                'assets/icons/feature.svg',
                color: AppColors.whiteColor,
              ),
            ),
          )
        ],
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                backgroundImage:
                    user?.profilePic != null && user?.profilePic != ''
                        ? Image.network(user!.profilePic).image
                        : Image.network(defaultProfPic).image,
              ),
            );
          },
        ),
        title: SvgPicture.asset(
          'assets/icons/logo.svg',
          color: Colors.white,
          height: 25,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () => Get.to(() => const UploadTweet()),
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
      body: StreamBuilder<List<Tweet>?>(
          stream: tweetProvider.getTweets(),
          builder: (context, AsyncSnapshot<List<Tweet>?> snapshot) {
            if (snapshot.hasData) {
              List<Tweet>? tweets = snapshot.data;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: tweets!.length,
                      itemBuilder: (context, index) {
                        Tweet tweet = tweets[index];
                        return FeedCard(tweet: tweet);
                      },
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 1.5,
                ),
              );
            }
          }),
    );
  }
}
