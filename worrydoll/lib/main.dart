import 'package:flutter/material.dart';

import 'SelectDoll/SelectDollPage.dart';
import 'core/home_with_bottom_bar.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorryDoll Demo',
      theme: ThemeData(
        fontFamily: 'ongle',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
