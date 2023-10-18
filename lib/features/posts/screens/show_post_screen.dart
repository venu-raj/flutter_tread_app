import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/error_screen.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/loader.dart';
import 'package:flutter_treads_clone_firebase/features/posts/screens/post_card.dart';
import 'package:flutter_treads_clone_firebase/features/posts/controller/post_controller.dart';

class ShowPostScreen extends ConsumerStatefulWidget {
  const ShowPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowPostScreenState();
}

class _ShowPostScreenState extends ConsumerState<ShowPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tread'),
      ),
      body: ref.watch(getAllPostsProvider).when(
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
    );
  }
}
