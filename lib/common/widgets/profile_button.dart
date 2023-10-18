import 'package:flutter/material.dart';
import 'package:flutter_treads_clone_firebase/theme/pallete.dart';

class ProfileButton extends StatelessWidget {
  final VoidCallback ontap;
  final String text;
  const ProfileButton({
    Key? key,
    required this.ontap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 30),
        backgroundColor: Pallete.backgroundColor,
        side: const BorderSide(
            color: Color.fromARGB(255, 138, 129, 129), width: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(text),
    );
  }
}
