import 'package:assignment3/pages/AboutPage.dart';
import 'package:assignment3/pages/ForecastPage.dart';
import 'package:assignment3/pages/HomePage.dart';
import 'package:assignment3/widgets/bottom_navigation.dart';
import 'package:assignment3/widgets/header.dart';
import 'package:flutter/material.dart';

const ColorScheme colors = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.yellow,
    onPrimary: Colors.yellow,
    secondary: Colors.black,
    onSecondary: Colors.yellow,
    error: Colors.yellow,
    onError: Colors.red,
    background: Colors.yellow,
    onBackground: Colors.yellow,
    surface: Color(0xFFEFBB3C),
    onSurface: Color(0xFFEFBB3C),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static const String api = '1287effc2be240fdcc22499bf2ffbc70';
  static double latitue = 0;
  static double longitude = 0;
  static bool positionDetermined = false;

  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Header
  final _headerKey = GlobalKey<HeaderState>();
  late final Header _header;
  // Used for Managing Header Items for each Page
  late final List<dynamic> _headerConfigs;

  // Pages (Middle Section)
  int _selectedIndex = 0;
  PageController? _pageController;
  late final List<Widget> _pages;

  // Bottom Navigation
  final _bottomNavKey = GlobalKey<BottomNavigationState>();

  _MyAppState() {

    // Header
    // Leading Image
    Padding img = Padding(padding: const EdgeInsets.all(0));

    // Header Title
    String title = "Weather App";
    _header = Header(key: _headerKey,);
    // 0 - Leading Widget
    // 1 - Title String
    // 2 - Actions []
    _headerConfigs = [
      [img, title, null],
      [img, title, null],
      [img, title, null],
    ];

    // Add Header content for "Current" page
    Future.delayed(const Duration(seconds: 1), () {
      _changeHeaderItems(_headerConfigs[_selectedIndex]);
    });

    // Pages (Middle Section)
    final homePageKey = GlobalKey<HomePageState>();
    final HomePage home = HomePage(key: homePageKey,);
    final forecastPageKey = GlobalKey<ForecastPageState>();
    final ForecastPage forecast = ForecastPage(key: forecastPageKey,);
    const AboutPage about = AboutPage();
    _pages = [home, forecast, about];
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: colors,
      ),
      home: Scaffold(
        appBar: _header,
        body: GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) => _handleHorizontalDrag(dragEndDetails),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          pressFunc: _changeScreen,
          key: _bottomNavKey,
        ),
      ),
    );
  }

  void _changeScreen(int index, bool animatedTransition) {
    if (_selectedIndex != index) {
      setState(() {
        // New Selected Page
        _selectedIndex = index;

        // Update Header Items
        _changeHeaderItems(_headerConfigs[_selectedIndex]);

        // Page Switching
        animatedTransition
        ? _pageController?.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastEaseInToSlowEaseOut
        )
        : _pageController?.jumpToPage(_selectedIndex);
      });
    }
  }

  void _changeHeaderItems(headerConfig) {
    _headerKey.currentState?.changeHeaderItems(headerConfig);
  }

  void _handleHorizontalDrag(DragEndDetails dragEndDetails) {
    double threshold = 1000.0; // How fast to swipe to activate page change
    double dragVelocity = dragEndDetails.velocity.pixelsPerSecond.dx;

    bool leftSwipe = dragVelocity <= (threshold*-1) ? true : false;
    bool rightSwipe = dragVelocity >= threshold ? true : false;

    int pagesCount = _pages.length;

    if (leftSwipe) {
      if (_selectedIndex != pagesCount-1) {
        int newIndex = _selectedIndex+1;
        _bottomNavKey.currentState?.updateIndex(newIndex);
        _changeScreen(newIndex, true);
      }
    }

    if (rightSwipe) {
      if (_selectedIndex != 0) {
        int newIndex = _selectedIndex-1;
        _bottomNavKey.currentState?.updateIndex(newIndex);
        _changeScreen(newIndex, true);
      }
    }
  }
}
