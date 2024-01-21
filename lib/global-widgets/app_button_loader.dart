import 'package:flutter/material.dart';

class AppButtonLoader extends StatelessWidget {
  const AppButtonLoader({super.key});

  @override
  Widget build(BuildContext context) => const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 10.0,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      );
}
