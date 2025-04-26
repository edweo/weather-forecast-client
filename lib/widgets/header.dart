import 'package:flutter/material.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  static const headerHeight = 60.0;

  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(headerHeight);

  @override
  State<StatefulWidget> createState() => HeaderState();
}

class HeaderState extends State<Header> {

  dynamic leading;
  String? title;
  List<dynamic>? actions;

  @override
  Widget build(BuildContext context) {

    return PreferredSize(
      preferredSize: const Size.fromHeight(Header.headerHeight),
      child: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: Header.headerHeight,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: leading ?? leading,
          ),
        ),
        title: Text(title ?? "",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
        actions: [
          actions != null ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(child: actions!.first),
          ) : const SizedBox.shrink()
        ],
      ),
    );
  }

  void changeHeaderItems(headerConfig) {
    var newLeading = headerConfig[0];
    var newTitle = headerConfig[1];
    var newActions = headerConfig[2];
    setState(() {
      leading = newLeading;
      title = newTitle;
      actions = newActions;
    });
  }
}