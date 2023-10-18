import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_treads_clone_firebase/models/reply_model.dart';
import 'package:flutter_treads_clone_firebase/theme/pallete.dart';

class CommentPostCard extends ConsumerWidget {
  final Replymodel replymodel;
  const CommentPostCard({
    required this.replymodel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posted = replymodel.datePublished;

    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(replymodel.profilePic),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  // // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(replymodel.userName),
                        Row(
                          children: [
                            Text(
                              timeago.format(posted, locale: 'en_short'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Pallete.greyColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      replymodel.text,
                      maxLines: null,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/like_outlined.svg',
                            color: Pallete.whiteColor,
                            height: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/comment.svg',
                            color: Pallete.whiteColor,
                            height: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/retweet.svg',
                            color: Pallete.whiteColor,
                            height: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
