import 'package:flutter/material.dart';
import 'package:worrydoll/SelectDoll/SelectDollPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SelectDollPage(),
    SelectDollPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'ongle',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
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
      ),
    );
  }
}
// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     debugShowCheckedModeBanner: false, // 디버그 배너 제거
//     title: '공대생 터치!',
//
//     // 앱 전체 테마 설정 (app_colors.dart 활용)
//     theme: ThemeData(
//       primaryColor: AppColors.customBlue,  // 기본 색상 설정
//       scaffoldBackgroundColor: AppColors.almostWhite,  // 배경색
//       fontFamily: 'cooper-bold-bt', // 기본 폰트 설정
//       textTheme: const TextTheme(
//         bodyLarge: TextStyle(color: Colors.black),
//       ),
//
//       inputDecorationTheme: InputDecorationTheme(
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(width: 2, color: AppColors.customBlue),
//         ),
//       ),
//
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: Colors.black,
//           overlayColor: Colors.transparent,
//         ),
//       ),
//       textSelectionTheme: const TextSelectionThemeData(
//         cursorColor: AppColors.customBlue,
//         selectionColor: AppColors.customBlue,
//         selectionHandleColor: AppColors.customBlue,
//       ),
//     ),
//
//     // 첫 화면 설정
//     home: BeforeLoginPage(),
//   );
// }
// }

