import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/type_defs.dart';
import 'package:flutter_treads_clone_firebase/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<User?> get authStateChange => auth.authStateChanges();

  FutureEither<UserModel> registerUser({
    required String email,
    required String password,
    required String username,
    required String fullname,
  }) async {
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        email: email,
        uid: cred.user!.uid,
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfSoM8--II9tah3UDPLceKdhnboAXwgZn5HR_D6iU&s',
        username: username,
        fullname: fullname,
        bio: '',
        followers: const [],
      );

      await firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(userModel.toMap());

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? ''));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(cred);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? ''));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel?> getUserData(String uid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .snapshots()
        .map(
            (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<void> logoutUser() {
    return auth.signOut();
  }

  Stream<List<UserModel>> userdataByName({
    required String query,
  }) {
    return firestore
        .collection('users')
        .where('username',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map((event) {
      List<UserModel> userModel = [];
      for (var user in event.docs) {
        userModel.add(UserModel.fromMap(user.data()));
      }
      return userModel;
    });
  }

  Future<void> followThePerson({
    required String uid,
    required String docId,
  }) async {
    DocumentSnapshot snap =
        await firestore.collection('users').doc(docId).get();
    List followers = (snap.data()! as dynamic)['followers'];

    if (followers.contains(docId)) {
      firestore.collection('users').doc(docId).update({
        'followers': FieldValue.arrayRemove([uid]),
      });
    } else {
      firestore.collection('users').doc(docId).update({
        'followers': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
