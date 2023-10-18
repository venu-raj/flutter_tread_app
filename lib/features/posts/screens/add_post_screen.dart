import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/loader.dart';
import 'package:flutter_treads_clone_firebase/core/utils.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/features/posts/controller/post_controller.dart';
import 'package:flutter_treads_clone_firebase/theme/pallete.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final TextEditingController postController = TextEditingController();
  Uint8List? image;

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
          text: postController.text,
          context: context,
          file: image!,
        );
  }

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text('New thread'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: postController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Start a thread...',
                                  hintStyle: TextStyle(
                                    color: Pallete.whiteColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    Uint8List file = await pickImage();
                                    setState(() {
                                      image = file;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.image,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.mic,
                                  ),
                                ),
                              ],
                            ),
                            image != null
                                ? Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: MemoryImage(
                                          image!,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 29.0, left: 20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          sharePost();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Post'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
