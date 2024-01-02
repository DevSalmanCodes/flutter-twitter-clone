import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/utils/snackbar.dart';

import '../constants/app_colors.dart';
import '../constants/image_strings.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment, required this.tweetId});
  final Comment comment;
  final String tweetId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profilePic),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.03,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.username,
                          style: const TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.02,
                        ),
                        Expanded(
                          child: Text(
                            timeago.format(comment.datePublished),
                            style: const TextStyle(
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      comment.comment,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: comment.uid == currentUserUid
                      ? () {
                          context
                              .read<TweetProvider>()
                              .deleteComment(tweetId, comment.commentId);
                          CustomSnackBar.success("Deleted");
                        }
                      : () => CustomSnackBar.error(
                          "You cannot modify this comment"),
                  icon: const Icon(Icons.more_vert))
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(commentIcon),
              SvgPicture.asset(retweetIcon),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        context.read<TweetProvider>().likeComment(
                            tweetId, comment.commentId, comment.likes);
                      },
                      icon: Icon(
                        comment.likes.contains(currentUserUid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: comment.likes.contains(currentUserUid)
                            ? Colors.red
                            : AppColors.greyColor,
                      )),
                  Text(
                    comment.likes.length.toString(),
                    style: const TextStyle(color: AppColors.greyColor),
                  )
                ],
              ),
              SvgPicture.asset(shareIcon),
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
