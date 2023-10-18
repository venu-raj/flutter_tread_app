import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/features/posts/repository/post_repository.dart';
import 'package:flutter_treads_clone_firebase/features/posts/screens/show_post_screen.dart';
import 'package:flutter_treads_clone_firebase/models/post_model.dart';
import 'package:flutter_treads_clone_firebase/models/reply_model.dart';
import 'package:flutter_treads_clone_firebase/utils/utils.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref.watch(postRepositoryProvider),
  );
});

final getAllPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getAllPosts();
});

final getCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getComments(postId: postId);
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getUsersPosts(uid: uid);
});

class PostController extends StateNotifier<bool> {
  final PostRepository postRepository;
  PostController(
    this.postRepository,
  ) : super(false);

  void sharePost({
    required String text,
    required BuildContext context,
    required Uint8List file,
  }) async {
    state = true;
    final res = await postRepository.sharePost(
      file: file,
      text: text,
      hashtags: _getHashtagsFromText(text),
    );
    state = false;

    res.fold((l) => showSnackBar(context, l.text), (r) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ShowPostScreen(),
        ),
      );
      showSnackBar(
        context,
        'posted',
      );
    });
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInsentences = text.split(' ');
    for (String word in wordsInsentences) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Stream<List<PostModel>> getAllPosts() {
    return postRepository.getAllPosts();
  }

  Stream<List<PostModel>> getUsersPosts({required String uid}) {
    return postRepository.getUsersPosts(uid: uid);
  }

  Future<void> likeThePost({
    required String postId,
    required List likes,
    required String uid,
  }) async {
    await postRepository.likeThePost(postId: postId, likes: likes, uid: uid);
  }

  Future<void> commentThePost({
    required String postId,
    required List commentIds,
    required String message,
  }) async {
    await postRepository.commentThePost(
      postId: postId,
      commentIds: commentIds,
      message: message,
    );
  }

  void postComment({
    required String postId,
    required String text,
  }) async {
    final res = await postRepository.postComment(
      postId: postId,
      text: text,
    );
    res.fold((l) => null, (r) => null);
  }

  Stream<List<Replymodel>> getComments({required String postId}) {
    return postRepository.getComments(postId: postId);
  }
}
