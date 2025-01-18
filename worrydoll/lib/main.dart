import 'package:flutter/material.dart';
import 'package:worrydoll/SelectDoll/SelectDollPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'ongle',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SelectDollPage(),
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

