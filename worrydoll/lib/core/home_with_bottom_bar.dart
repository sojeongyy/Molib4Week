import 'package:flutter/material.dart';
import 'package:worrydoll/WorryDoll/WorryDollHelloPage.dart';
//import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeWithBottomBar extends StatefulWidget {
  @override
  _HomeWithBottomBarState createState() => _HomeWithBottomBarState();
}

class _HomeWithBottomBarState extends State<HomeWithBottomBar> {
  int _currentIndex = 0;

  // 예시 스크린
  final List<Widget> _screens = [
    WorryDollHelloPage(),
    Center(child: Text('Business Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cruelty_free),
            label: '걱정인형',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: '걱정일기',
          ),
        ],
      ),
    );
  }
}
