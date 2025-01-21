import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/WorryDoll/widgets/balloon_card.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';

import '../core/DollProvider.dart';
import '../core/colors.dart';
import 'DragBalloonPage.dart';


class WorryingPage extends StatefulWidget {
  @override
  _WorryingPageState createState() => _WorryingPageState();
}

class _WorryingPageState extends State<WorryingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final String firstMessage =
      "지금 많이 힘들겠지만, 너무 애쓰지 않아도 괜찮아. 네가 할 수 있는 만큼만 해도 충분해!";
  final String secondMessage = "이 걱정은 내가 짊어질테니 이제 푹 쉬어. 좋은 꿈 꿔!";

  List<String> _displayedWords = [];
  int _currentWordIndex = 0;
  bool _showFirstMessage = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingEffect(firstMessage);

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
  void _startTypingEffect(String message) {
    _timer?.cancel(); // 기존 타이머 취소
    List<String> words = message.split(' '); // 메시지를 단어별로 나누기
    _displayedWords = [];
    _currentWordIndex = 0;

    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (_currentWordIndex < words.length) {
        setState(() {
          _displayedWords.add(words[_currentWordIndex]);
          _currentWordIndex++;
        });
      } else {
        timer.cancel(); // 모든 단어가 표시되면 타이머 중지
        if (!_showFirstMessage) {
          // 버튼 활성화
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _buildWorryingPage(context),
        );
      },
    );
  }

  Widget _buildWorryingPage(BuildContext context) {

    final selectedDollImagePath =
        Provider.of<DollProvider>(context).selectedDollImagePath ??
            'assets/images/dolls/default.png'; // 선택되지 않았을 경우 기본 이미지

    return Scaffold(
      body: Stack(
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
            top: 100,
            left: 0,
            right: 0,   // left와 right를 모두 0으로 두고
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

          // 말풍선
          Positioned(
            top: 390,
            left: 20,
            right: 20,
            child: BalloonCard(
              content: _displayedWords.join(' '), // 현재까지 표시된 단어를 이어서 표시
            ),
          ),


          // 걱정 털어놓기 버튼(절대 위치, 고정 크기)
          if (!_showFirstMessage)
          Positioned(
            top: 570,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 305,
                height: 50,
                child: WorryButton(
                  text: '다른 걱정 털어놓기',
                  onPressed: () {
                    // Navigator를 사용해 MyWorryPage로 이동
                    _navigatorKey.currentState!.push(
                      MaterialPageRoute(builder: (context) => DragBalloonPage()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _switchToSecondMessage() {
    setState(() {
      _showFirstMessage = false;
    });
    _startTypingEffect(secondMessage);
  }
}
