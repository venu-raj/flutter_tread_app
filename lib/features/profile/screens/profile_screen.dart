import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/error_screen.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/loader.dart';
import 'package:flutter_treads_clone_firebase/common/widgets/profile_button.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/controller/post_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/screens/post_card.dart';
import 'package:flutter_treads_clone_firebase/theme/pallete.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const ProfileScreen({
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  var userDetails = {};

  getDataByUid() async {
    try {
      var userdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userDetails = userdata.data()!;
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getDataByUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.watch(authControllerProvider.notifier).logoutUser();
          },
          icon: const Icon(
            Icons.work_outlined,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_box,
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userDetails['fullname'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userDetails['username'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  userDetails['bio'].isEmpty
                      ? const SizedBox()
                      : Text(userDetails['bio']),
                  Text(
                    '${userDetails['followers'].length} followers',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Pallete.greyColor,
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userDetails['photoUrl']),
                  radius: 30,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FirebaseAuth.instance.currentUser!.uid == widget.uid
                  ? ProfileButton(
                      ontap: () {},
                      text: 'Edit profile',
                    )
                  : ProfileButton(
                      ontap: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .followThePerson(
                              uid: ref.watch(userProvider)!.uid,
                              docId: widget.uid,
                            );
                      },
                      text: userDetails['followers']
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? 'unfollow'
                          : 'follow',
                    ),
              ProfileButton(
                ontap: () {},
                text: 'Share profile',
              ),
            ],
          ),
          Expanded(
            child: ref.watch(getUserPostsProvider(widget.uid)).when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = data[index];
                        return PostCard(
                          postModel: post,
                        );
                      },
                    );
                  },
                  error: (error, st) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                ),
          ),
        ],
      ),
    );
  }
}
