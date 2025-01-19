import 'package:flutter/material.dart';
import 'package:worrydoll/DiaryCover/DiaryCoverPage.dart';
import 'package:worrydoll/WorryDoll/WorryDollHelloPage.dart';

import 'colors.dart';
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
    DiaryCoverPage(),
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
        backgroundColor: AppColors.blue, // 하단바 배경색
        selectedItemColor: AppColors.pink,    // 선택된 아이템 색상
        unselectedItemColor: Colors.black54, // 선택되지 않은 아이템 색상
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
