import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/constants/strings.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/providers/user_provider.dart';
import 'package:twitter/screens/edit_profile.dart';
import 'package:twitter/screens/upload_tweet.dart';
import 'package:twitter/widgets/feed_card.dart';
import 'package:twitter/widgets/follow_button.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final provider = Provider.of<TweetProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () => Get.to(() => const UploadTweet()),
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream:
                    firestore.collection(usersCollection).doc(uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                    radius: 30,
                                    backgroundImage: data['profilePic'] !=
                                                null &&
                                            data['profilePic'] != ''
                                        ? NetworkImage(data['profilePic'])
                                        : const NetworkImage(defaultProfPic)),
                                if (uid == currentUserUid)
                                  FollowButton(
                                    width: 135,
                                    height: 20,
                                    borderColor: AppColors.greyColor,
                                    text: 'Edit Profile',
                                    buttonColor: Colors.transparent,
                                    onPressed: () =>
                                        Get.to(() => const EditProfile()),
                                    textColor: AppColors.whiteColor,
                                  )
                                else
                                  data['followers'].contains(currentUserUid)
                                      ? FollowButton(
                                          width: 130,
                                          height: 20,
                                          textColor: AppColors.whiteColor,
                                          buttonColor: Colors.transparent,
                                          borderColor: AppColors.greyColor,
                                          text: 'Following',
                                          onPressed: () => context
                                              .read<UserProvider>()
                                              .followUser(data['followers'],
                                                  data['uid']),
                                        )
                                      : FollowButton(
                                          width: 130,
                                          height: 20,
                                          textColor: AppColors.blackColor,
                                          text: 'Follow',
                                          onPressed: () => context
                                              .read<UserProvider>()
                                              .followUser(data['followers'],
                                                  data['uid']),
                                        ),
                              ]),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            data['username'],
                            style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          if (data['bio'] != '')
                            Text(
                              data['bio'],
                              style:
                                  const TextStyle(color: AppColors.whiteColor),
                            ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    data['following'].length.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.whiteColor,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  const Text(
                                    "Following",
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  Text(
                                    data['followers'].length.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.whiteColor,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  const Text(
                                    "Followers",
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
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
                }),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade800,
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<List<Tweet>>(
                stream: provider.getUserTweets(uid),
                builder: (context, AsyncSnapshot<List<Tweet>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, int index) {
                          Tweet tweet = snapshot.data![index];
                          return FeedCard(tweet: tweet);
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
