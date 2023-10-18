import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/controller/post_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/screens/comment_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_treads_clone_firebase/models/post_model.dart';
import 'package:flutter_treads_clone_firebase/theme/pallete.dart';

class PostCard extends ConsumerWidget {
  final PostModel postModel;
  PostCard({
    required this.postModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final posted = postModel.createdAt;

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundImage: NetworkImage(postModel.profilePic),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        postModel.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                  postModel.text,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: Image.network(
                    postModel.imageLinks!,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.watch(postControllerProvider.notifier).likeThePost(
                              postId: postModel.postId,
                              likes: postModel.likes,
                              uid: user.uid,
                            );
                      },
                      icon: postModel.likes.contains(user.uid)
                          ? SvgPicture.asset(
                              'assets/icons/like_filled.svg',
                              color: Pallete.redColor,
                              height: 20,
                            )
                          : SvgPicture.asset(
                              'assets/icons/like_outlined.svg',
                              color: Pallete.whiteColor,
                              height: 25,
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              post: postModel,
                            ),
                          ),
                        );
                      },
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
                Text(
                  '${postModel.commentIds.length} replies . ${postModel.likes.length} likes',
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
