import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    await dotenv.load();
    final String baseUrl = dotenv.env['API_URL']!;
    final today = DateTime.now();

    // 오늘 날짜를 KST로 변환 후 문자열로 포맷
    final String formattedDate =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    try {
      // 수정: API 요청으로 오늘 날짜의 데이터를 가져옴
      final response = await http.get(Uri.parse('$baseUrl?date=$formattedDate'));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedBody);

        setState(() {
          balloonData = data
              .cast<Map<String, dynamic>>()
              .where((entry) => entry['is_resolved'] == false) // is_resolved=false만 포함
              .toList();
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        balloonData = []; // 데이터 비우기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다: $e')),
        );
      });
    }
  }

  Future<void> _resolveWorry(int worryId) async {
    await dotenv.load(); // .env 파일 로드
    final String baseUrl = dotenv.env['API_URL']!;
    final url = Uri.parse('$baseUrl$worryId/resolve');
    print (url);

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('풍선이 성공적으로 터졌습니다!')),
        );
      } else {
        throw Exception('Failed to resolve worry: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    }
  }


  void _showWorryDialog(int index) {
    final data = balloonData[index];
    showDialog(
      context: context,
      //barrierDismissible: true,
      builder: (context) => WorryDialog(
        time: DateTime.parse(data['date_created']).add(Duration(hours: -3)),
        worry: data['content'],
        advice: data['comfort_message'],
        onPopBalloon: () async {
          await _resolveWorry(data['id']);

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


        ..._buildBalloons(),
      ],
    );
  }
}
