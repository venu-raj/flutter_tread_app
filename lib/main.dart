import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/error_screen.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/loader.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/features/auth/screens/login_screen.dart';
import 'package:flutter_treads_clone_firebase/features/home/screens/home_screen.dart';
import 'package:flutter_treads_clone_firebase/firebase_options.dart';
import 'package:flutter_treads_clone_firebase/models/user_model.dart';
import 'package:flutter_treads_clone_firebase/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treads Clone',
      theme: AppTheme.theme,
      home: ref.watch(authStateChagesProvider).when(
            data: (user) {
              if (user != null) {
                getData(ref, user);
                if (userModel != null) {
                  return const HomeScreen();
                }
              }
              return const LoginScreen();
            },
            error: (error, st) {
              return ErrorScreen(
                error: error.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
