import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/TodayWorry/widgets/BalloonDisplayTab.dart';
import 'package:worrydoll/TodayWorry/widgets/WorryDialog.dart';

import '../core/DollProvider.dart';
import '../core/colors.dart';

class TodayWorryPage extends StatefulWidget {
  @override
  _TodayWorryPageState createState() => _TodayWorryPageState();
}

class _TodayWorryPageState extends State<TodayWorryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  List<Map<String, dynamic>> balloonData = []; // JSON 데이터 저장
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadDiaryData();

    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 반복 시간
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복 (좌우로 흔들림)

    // 좌우 흔들림을 위한 Animation 설정 (각도 -0.05 ~ 0.05 라디안)
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }

  Future<void> _loadDiaryData() async {
    // JSON 파일 로드
    final String jsonString =
    await rootBundle.loadString('assets/json/diary_dummy_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    // 오늘 날짜 기준으로 필터링
    final today = DateTime.now();
    setState(() {
      balloonData = jsonData
          .where((entry) {
        final date = DateTime.parse(entry['date_created']);
        return date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
      })
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }


  void _showWorryDialog(int index) {
    final data = balloonData[index];
    showDialog(
      context: context,
      //barrierDismissible: true,
      builder: (context) => WorryDialog(
        time: DateTime.parse(data['date_created']),
        worry: data['content'],
        advice: data['comfort_message'],
        onPopBalloon: () {
          Navigator.pop(context); // 다이얼로그 닫기 먼저 실행
          setState(() {
            balloonData.removeAt(index); // 풍선 데이터를 삭제
          });
        },
        backgroundColor: index == 0 ? AppColors.pink : AppColors.yellow, // 색상 설정
        buttonColor: index == 0 ? AppColors.yellow : AppColors.pink, // 버튼 색상 설정
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Navigator(
  //     key: _navigatorKey,
  //     onGenerateRoute: (settings) {
  //       return MaterialPageRoute(
  //         builder: (context) => _buildHelloPage(context),
  //       );
  //     },
  //   );
  // }

  List<Widget> _buildBalloons() {
    return balloonData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      // 풍선 이미지 경로 결정
      final balloonColor = data['balloon_color'] == 1
          ? 'red'
          : data['balloon_color'] == 2
          ? 'yellow'
          : 'blue';
      final balloonImagePath = 'assets/images/balloons/${balloonColor}_balloon.png';

      final mediaQuery = MediaQuery.of(context).size;

      // 인형의 위치와 크기 정의
      final dollWidth = 170.0; // 인형의 가로 크기
      final dollHeight = 200.0; // 인형의 세로 크기
      final dollTop = 200.0; // 인형의 Y 위치
      final dollLeft = (mediaQuery.width - dollWidth) / 2; // 인형의 X 위치 (중앙 정렬)

      // 풍선의 랜덤 위치 계산
      double leftOffset;
      double topOffset;
      do {
        leftOffset = _random.nextDouble() * mediaQuery.width * 0.8;
        topOffset = _random.nextDouble() * mediaQuery.height * 0.5;
      } while (
      // 풍선이 인형 영역과 겹치지 않도록 조건 설정
      leftOffset < dollLeft + dollWidth &&
          leftOffset + 100 > dollLeft && // 100은 풍선의 가로 크기
          topOffset < dollTop + dollHeight &&
          topOffset + 100 > dollTop); // 100은 풍선의 세로 크기

      return Positioned(
        left: leftOffset,
        top: topOffset,
        child: GestureDetector(
          onTap: () => _showWorryDialog(index),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(_animation.value),
                child: child,
              );
            },
            child: Image.asset(
              balloonImagePath,
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _buildHelloPage(context),
        );
      },
    );
  }

  Widget _buildHelloPage(BuildContext context) {

    // 선택된 인형 이미지 경로 가져오기
    final selectedDollImagePath =
        Provider.of<DollProvider>(context).selectedDollImagePath ??
            'assets/images/dolls/default.png'; // 선택되지 않았을 경우 기본 이미지


    return Stack(
      children: [
        // 전체 배경
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),


        // 토끼 인형 이미지(절대 위치, 고정 크기)
        Positioned(
          top: 200,
          left: 0,
          right: 0, // left와 right를 모두 0으로 두고
          child: Align(
            alignment: Alignment.topCenter, // 수평 중앙
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.bottomCenter, // 엉덩이 고정
                  transform: Matrix4.rotationZ(_animation.value), // 좌우 흔들림
                  child: child,
                );
              },
              child: Image.asset(
                selectedDollImagePath,
                width: 170,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),


        // BalloonDisplay(
        //   balloonSize: 150, // 풍선 크기 조정
        //   redBalloonOffset: Offset(70, 170), // 빨간 풍선 위치
        //   yellowBalloonOffset: Offset(70, 170), // 노란 풍선 위치
        // ),
        // 풍선 디스플레이

          // BalloonDisplayTab(
          //   balloonSize: 150,
          //   onRedBalloonTap: balloonData.isNotEmpty ? () => _showWorryDialog(0) : null,
          //   onYellowBalloonTap: balloonData.length > 1 ? () => _showWorryDialog(1) : null, // 두 번째 데이터가 있을 경우만
          // ),
        ..._buildBalloons(),
      ],
    );
  }
}
