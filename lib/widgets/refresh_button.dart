import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  Function? onPress;
  RefreshButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      right: 5,
      child: IconButton(
        onPressed: () {
          onPress!();
        },
        icon: const Icon(Icons.refresh),
        iconSize: 35,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

}