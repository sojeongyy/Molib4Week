import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'SelectDoll/SelectDollPage.dart';
import 'core/colors.dart';
import 'core/home_with_bottom_bar.dart';



void main() async {
  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorryDoll',
      theme: ThemeData(
        fontFamily: 'ongle',
        // colorScheme: ColorScheme.fromSeed(seedColor: ),
        useMaterial3: true,
        primaryColor: AppColors.pink,  // 기본 색상 설정
        //scaffoldBackgroundColor: AppColors.a,  // 배경색
        textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        )
      ),
      // 초기 라우트: SelectDollPage (하단바 없음)
      initialRoute: '/',
      routes: {
        '/': (context) => SelectDollPage(),      // 인형 선택 페이지
        '/home': (context) => HomeWithBottomBar() // 메인 페이지(하단바 있음)
      },
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