import 'package:flutter/material.dart';

class HomeWithBottomBar extends StatefulWidget {
  @override
  _HomeWithBottomBarState createState() => _HomeWithBottomBarState();
}

class _HomeWithBottomBarState extends State<HomeWithBottomBar> {
  int _currentIndex = 0;

  // 예시 스크린
  final List<Widget> _screens = [
    Center(child: Text('Home Screen')),
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
