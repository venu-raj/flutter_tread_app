import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/features/auth/repository/auth_repository.dart';
import 'package:flutter_treads_clone_firebase/features/home/screens/home_screen.dart';
import 'package:flutter_treads_clone_firebase/models/user_model.dart';
import 'package:flutter_treads_clone_firebase/utils/utils.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref,
  );
});

final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateChagesProvider = StreamProvider((ref) {
  return ref.watch(authControllerProvider.notifier).authStateChange;
});

final getUserdataProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(authControllerProvider.notifier).getUserData(uid);
});

final userdataByNameProvider = StreamProvider.family((ref, String query) {
  return ref
      .watch(authControllerProvider.notifier)
      .userdataByName(query: query);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository authRepository;
  final Ref ref;
  AuthController(
    this.authRepository,
    this.ref,
  ) : super(false);

  Stream<User?> get authStateChange => authRepository.authStateChange;

  void createUser({
    required String email,
    required String password,
    required String username,
    required String fullname,
    required BuildContext context,
  }) async {
    state = true;
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        username.isNotEmpty &&
        fullname.isNotEmpty) {
      final res = await authRepository.registerUser(
        email: email,
        password: password,
        username: username,
        fullname: fullname,
      );

      state = false;
      res.fold(
        (l) => showSnackBar(context, l.text),
        (userModel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          ref.watch(userProvider.notifier).update((state) => userModel);
        },
      );
    } else {
      showSnackBar(context, 'please fill all the fields');
    }
  }

  void loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;

    final res = await authRepository.loginUser(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.text),
      (r) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
  }

  Stream<UserModel?> getUserData(String uid) {
    return authRepository.getUserData(uid);
  }

  Future<void> logoutUser() {
    return authRepository.logoutUser();
  }

  Stream<List<UserModel>> userdataByName({
    required String query,
  }) {
    return authRepository.userdataByName(query: query);
  }

  Future<void> followThePerson({
    required String uid,
    required String docId,
  }) async {
    return await authRepository.followThePerson(
      uid: uid,
      docId: docId,
    );
  }
}
