import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/error_screen.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/loader.dart';
import 'package:flutter_treads_clone_firebase/common/widgets/auth_text_field.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/controller/post_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/screens/comment_post_card.dart';
import 'package:flutter_treads_clone_firebase/models/post_model.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final PostModel post;
  const CommentScreen({
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tread'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
            ),
          ),
        ],
      ),
      body: ref.watch(getCommentsProvider(widget.post.postId)).when(
            data: (data) {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final reply = data[index];
                    return CommentPostCard(replymodel: reply);
                  });
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 8, right: 8),
        child: Row(
          children: [
            Expanded(
              child: AuthTextFeild(
                textEditingController: commentController,
                hintText: 'reply as ${user.fullname}',
                textInputType: TextInputType.text,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(postControllerProvider.notifier).postComment(
                      postId: widget.post.postId,
                      text: commentController.text,
                    );
              },
              child: TextButton(
                onPressed: () {
                  ref.read(postControllerProvider.notifier).postComment(
                        postId: widget.post.postId,
                        text: commentController.text,
                      );

                  ref.read(postControllerProvider.notifier).commentThePost(
                        postId: widget.post.postId,
                        commentIds: [widget.post.text],
                        message: commentController.text,
                      );
                  setState(() {
                    commentController.text = '';
                  });
                },
                child: const Text(
                  'Post',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
