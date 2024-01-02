import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/image_strings.dart';
import 'package:twitter/models/tweet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter/screens/comments.dart';
import 'package:twitter/screens/profile.dart';

import '../constants/app_colors.dart';
import '../constants/firebase_consts.dart';
import '../constants/strings.dart';
import '../providers/tweet_provider.dart';
import '../utils/snackbar.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({super.key, required this.tweet});
  final Tweet tweet;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  int commentLength = 0;
  @override
  void initState() {
    countComment();
    super.initState();
  }

  Future<void> countComment() async {
    final snap = await firestore
        .collection(tweetsCollection)
        .doc(widget.tweet.tweetId)
        .collection(commentCollection)
        .get();

    if (mounted) {
      setState(() {
        commentLength = snap.docs.length;
      });
    }
  }

  Future<void> deletePost() async {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text(
              'Delete Tweet?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text('Are you sure you want to delete this tweet?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.blackColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<TweetProvider>()
                      .deleteTweet(widget.tweet.tweetId);
                  Get.back();
                  CustomSnackBar.success("Deleted");
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final tweetProvider = Provider.of<TweetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => Profile(uid: widget.tweet.uid)),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.tweet.profImage != ''
                          ? widget.tweet.profImage
                          : defaultProfPic)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.tweet.username,
                  style: const TextStyle(color: AppColors.whiteColor),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Text(
                    timeago.format(widget.tweet.datePublished),
                    style: const TextStyle(color: AppColors.whiteColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.tweet.uid == currentUserUid) {
                      deletePost();
                    } else {
                      CustomSnackBar.error("You cannot modify this tweet");
                    }
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          if (widget.tweet.description != '')
            const SizedBox(
              height: 8.0,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              widget.tweet.description,
              style: const TextStyle(color: AppColors.whiteColor),
            ),
          ),
          widget.tweet.photoUrl != ''
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: MediaQuery.sizeOf(context).width,
                  height: height * 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CachedNetworkImage(
                      progressIndicatorBuilder:
                          (context, url, downoadProgress) {
                        return Center(
                          child: CircularProgressIndicator(
                            value: downoadProgress.progress,
                            color: Colors.blue,
                            strokeWidth: 1.5,
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                      imageUrl: widget.tweet.photoUrl!,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ))
              : Container(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () => Get.to(() => Comments(
                              tweet: widget.tweet,
                            )),
                        child: SvgPicture.asset(commentIcon, height: 18)),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      commentLength.toString(),
                      style: const TextStyle(color: AppColors.greyColor),
                    )
                  ],
                ),
                SvgPicture.asset(retweetIcon, height: 18),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => tweetProvider.likeTweet(
                          widget.tweet.tweetId, widget.tweet.likes),
                      child: Icon(
                        widget.tweet.likes.contains(currentUserUid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: widget.tweet.likes.contains(currentUserUid)
                            ? Colors.red
                            : Colors.grey,
                        size: 23,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.tweet.likes.length.toString(),
                      style: const TextStyle(color: AppColors.greyColor),
                    )
                  ],
                ),
                SvgPicture.asset(shareIcon, height: 18)
              ],
            ),
          )
        ],
      ),
    );
  }
}
