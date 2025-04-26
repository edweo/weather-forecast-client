import 'package:flutter/material.dart';

const navOptions = [
  BottomNavigationBarItem(
      icon: Icon(Icons.access_time_outlined),
      label: "Current"
  ),
  BottomNavigationBarItem(
      icon: Icon(Icons.sunny),
      label: "Forecast"
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.info),
    label: "About",
  ),
];

class BottomNavigation extends StatefulWidget {
  late final Function? onPressFunc;

  BottomNavigation({super.key, Function? pressFunc}) {
    onPressFunc = pressFunc;
  }

  @override
  State<StatefulWidget> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: navOptions,
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      onTap: _onBarClick,
    );
  }

  void _onBarClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onPressFunc!(index, false);
  }

  void updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}