import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String loadingText;
  const LoadingScreen({super.key, required this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 15,),
        Text(loadingText,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}