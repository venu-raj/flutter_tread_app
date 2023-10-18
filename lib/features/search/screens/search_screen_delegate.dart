import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/error_screen.dart';
import 'package:flutter_treads_clone_firebase/common/reuseable_components/loader.dart';
import 'package:flutter_treads_clone_firebase/features/auth/controller/auth_controller.dart';
import 'package:flutter_treads_clone_firebase/features/profile/screens/profile_screen.dart';
import 'package:flutter_treads_clone_firebase/theme/pallete.dart';

class ShowSearchScreenDelegate extends SearchDelegate {
  final WidgetRef ref;
  ShowSearchScreenDelegate({
    required this.ref,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
          context,
          null,
        );
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(userdataByNameProvider(query)).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final user = data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  title: Text(user.username),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                uid: user.uid,
                              )),
                    );
                  },
                );
              },
            );
          },
          error: (error, st) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Pallete.backgroundColor,
    );
  }
}
