import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/constants/strings.dart';
import 'package:twitter/models/comment.dart' as comment;
import 'package:twitter/models/tweet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/utils/snackbar.dart';
import 'package:twitter/widgets/comment_card.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, required this.tweet});
  final Tweet tweet;
  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  FocusNode focusNode = FocusNode();
  final commentController = TextEditingController();
  bool isFocused = false;
  int commentLength = 0;

  @override
  void initState() {
    length(widget.tweet.tweetId);
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    commentController.dispose();
    super.dispose();
  }

  Future<void> length(id) async {
    var data = await firestore
        .collection(tweetsCollection)
        .doc(id)
        .collection(commentCollection)
        .get();
    commentLength = data.docs.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    final tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(bottom: keyboardSize),
        child: Row(
          children: [
            Expanded(
                child: Focus(
              onFocusChange: (value) {
                setState(() {
                  isFocused = value;
                });
              },
              child: TextField(
                style: const TextStyle(color: AppColors.whiteColor),
                controller: commentController,
                focusNode: focusNode,
                decoration: InputDecoration(
                    label: isFocused
                        ? Text(
                            widget.tweet.uid == currentUserUid
                                ? 'Replying to yourself'
                                : 'Replying to ${widget.tweet.username}',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )
                        : null,
                    hintText: 'Post your reply'),
              ),
            )),
            TextButton(
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    tweetProvider.postComment(
                        widget.tweet.tweetId, commentController.text);
                    CustomSnackBar.success("Posted");
                    commentController.clear();
                  } else {
                    CustomSnackBar.error("Comment cannot be empty");
                  }
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      )),
      appBar: AppBar(
          foregroundColor: AppColors.whiteColor,
          title: const Text(
            'Post',
            style: TextStyle(color: AppColors.whiteColor),
          )),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            StreamBuilder(
                stream: firestore
                    .collection(tweetsCollection)
                    .doc(widget.tweet.tweetId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: data!['profImage'] != ''
                                    ? NetworkImage(data['profImage'])
                                    : const NetworkImage(defaultProfPic),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Text(
                                  data['username'],
                                  style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.whiteColor),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            data['description'],
                            style: const TextStyle(color: AppColors.whiteColor),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          if (data['photoUrl'] != '')
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: data['photoUrl'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            timeago.format(
                                (data['datePublished'] as Timestamp).toDate()),
                            style: const TextStyle(color: AppColors.whiteColor),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Divider(
                            color: Colors.grey.shade900,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            '${data['likes'].length} Likes',
                            style: const TextStyle(color: AppColors.whiteColor),
                          ),
                          Divider(
                            color: Colors.grey.shade900,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/comment.svg',
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    commentLength.toString(),
                                    style: const TextStyle(
                                        color: AppColors.greyColor),
                                  )
                                ],
                              ),
                              SvgPicture.asset(
                                'assets/icons/retweet.svg',
                                height: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    tweetProvider.likeTweet(
                                        widget.tweet.tweetId, data['likes']);
                                  },
                                  child: Icon(
                                    data['likes'].contains(currentUserUid)
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color:
                                        data['likes'].contains(currentUserUid)
                                            ? Colors.red
                                            : Colors.grey,
                                  )),
                              SvgPicture.asset(
                                'assets/icons/bookmarks.svg',
                                height: 20,
                              ),
                              SvgPicture.asset(
                                'assets/icons/share.svg',
                                height: 20,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Divider(
                            color: Colors.grey.shade900,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.blue));
                  }
                }),
            StreamBuilder<List<comment.Comment>?>(
                stream: tweetProvider.getComments(widget.tweet.tweetId),
                builder:
                    (context, AsyncSnapshot<List<comment.Comment>?> snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final comment = snapshot.data![index];
                            return CommentCard(
                              comment: comment,
                              tweetId: widget.tweet.tweetId,
                            );
                          }),
                    );
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
