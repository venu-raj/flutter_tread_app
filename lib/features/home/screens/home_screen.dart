import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/screens/add_post_screen.dart';
import 'package:flutter_treads_clone_firebase/features/posts/screens/show_post_screen.dart';
import 'package:flutter_treads_clone_firebase/features/profile/screens/profile_screen.dart';
import 'package:flutter_treads_clone_firebase/features/search/screens/search_screen.dart';
import 'package:flutter_treads_clone_firebase/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const ShowPostScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const Text('notification screen'),
          ProfileScreen(
            uid: user!.uid,
          )
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        backgroundColor: Pallete.backgroundColor,
        activeColor: Pallete.whiteColor,
        inactiveColor: Pallete.greyColor,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentIndex == 0
                  ? 'assets/icons/home_filled.svg'
                  : 'assets/icons/home_outlined.svg',
              color:
                  _currentIndex == 0 ? Pallete.whiteColor : Pallete.greyColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_sharp,
              color:
                  _currentIndex == 1 ? Pallete.whiteColor : Pallete.greyColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddPostScreen(),
                  ),
                );
              },
              icon: Icon(
                  _currentIndex == 2 ? Icons.upload : Icons.upload_outlined),
              color:
                  _currentIndex == 2 ? Pallete.whiteColor : Pallete.greyColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 3
                ? SvgPicture.asset(
                    'assets/icons/like_filled.svg',
                    height: 20,
                    color: _currentIndex == 3
                        ? Pallete.whiteColor
                        : Pallete.greyColor,
                  )
                : SvgPicture.asset(
                    'assets/icons/like_outlined.svg',
                    height: 25,
                    color: _currentIndex == 3
                        ? Pallete.whiteColor
                        : Pallete.greyColor,
                  ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 4 ? Icons.person_3 : Icons.person_3_outlined,
              color:
                  _currentIndex == 4 ? Pallete.whiteColor : Pallete.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
