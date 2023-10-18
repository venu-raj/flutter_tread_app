import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/type_defs.dart';
import 'package:flutter_treads_clone_firebase/core/storage_methods.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/models/post_model.dart';
import 'package:flutter_treads_clone_firebase/models/reply_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: FirebaseFirestore.instance,
    ref: ref,
  );
});

class PostRepository {
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  PostRepository({
    required this.firestore,
    required this.ref,
  });

  FutureEither<PostModel> sharePost({
    required String text,
    required List<String> hashtags,
    required Uint8List file,
  }) async {
    try {
      final user = ref.watch(userProvider)!;
      final postDocId = const Uuid().v1();
      final imageLinks = await StorageMethods().uploadImageToStorage(
        'posts',
        file,
        true,
      );

      PostModel postModel = PostModel(
        text: text,
        hashtags: hashtags,
        imageLinks: imageLinks,
        uid: user.uid,
        createdAt: DateTime.now(),
        likes: [],
        commentIds: [],
        postId: postDocId,
        sharedCount: 0,
        username: user.fullname,
        profilePic: user.photoUrl,
      );

      await firestore.collection('posts').doc(postDocId).set(postModel.toMap());

      return right(postModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getAllPosts() {
    return firestore.collection('posts').snapshots().map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<PostModel>> getUsersPosts({required String uid}) {
    return firestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Future<void> likeThePost({
    required String postId,
    required List likes,
    required String uid,
  }) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {}
  }

  Future<void> commentThePost({
    required String postId,
    required List commentIds,
    required String message,
  }) async {
    try {
      await firestore.collection('posts').doc(postId).update({
        'commentIds': FieldValue.arrayUnion([message])
      });
    } catch (e) {}
  }

  FutureEither<Replymodel> postComment({
    required String postId,
    required String text,
  }) async {
    try {
      final commentDocid = const Uuid().v1();
      final user = ref.watch(userProvider)!;

      Replymodel replymodel = Replymodel(
        profilePic: user.photoUrl,
        userName: user.fullname,
        useruid: user.uid,
        text: text,
        commentId: commentDocid,
        datePublished: DateTime.now(),
      );

      await firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentDocid)
          .set(replymodel.toMap());

      return right(replymodel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Replymodel>> getComments({
    required String postId,
  }) {
    return firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => Replymodel.fromMap(e.data())).toList(),
        );
  }
}
