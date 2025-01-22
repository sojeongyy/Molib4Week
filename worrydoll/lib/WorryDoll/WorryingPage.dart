import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/WorryDoll/MyWorryPage.dart';
import 'package:worrydoll/WorryDoll/WorryDollHelloPage.dart';
import 'package:worrydoll/WorryDoll/widgets/BalloonDisplay.dart';
import 'package:worrydoll/WorryDoll/widgets/balloon_card.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';

import '../core/DollProvider.dart';
import '../core/colors.dart';
import 'DragBalloonPage.dart';


class WorryingPage extends StatefulWidget {
  final String audioUrl;
  final String comfortMessage;

  WorryingPage({required this.audioUrl, required this.comfortMessage});

  @override
  _WorryingPageState createState() => _WorryingPageState();
}

class _WorryingPageState extends State<WorryingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late String firstMessage;
  final String secondMessage = "이 걱정은 내가 짊어질테니 이제 푹 쉬어. 좋은 꿈 꿔!";

  AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _textUpdateTimer;

  List<String> _displayedWords = [];
  int _currentWordIndex = 0;
  bool _showFirstMessage = true;
  Timer? _timer;
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    firstMessage = widget.comfortMessage;
    _playAudio(widget.audioUrl, firstMessage);
    //_startTypingEffect(firstMessage);

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

    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) { // 이걸로 속도 조정 가능!
      if (_currentWordIndex < words.length) {
        setState(() {
          _displayedWords.add(words[_currentWordIndex]);
          _currentWordIndex++;
        });
      } else {
        timer.cancel(); // 모든 단어가 표시되면 타이머 중지
        if (_showFirstMessage) {
          // 첫 번째 메시지가 끝난 후 두 번째 메시지로 전환
          Future.delayed(Duration(milliseconds: 500), () {
            _switchToSecondMessage();
          });
        }
      }
    });
  }

  Future<void> _playAudio(String url, String comfortMessage) async {
    final words = comfortMessage.split(' ');
    int wordIndex = 0;

    await _audioPlayer.play(UrlSource(url));
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _displayedText = comfortMessage;
      });
    });

    setState(() {
      _displayedText = '';
    });

    _textUpdateTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (wordIndex < words.length) {
        setState(() {
          _displayedText += '${words[wordIndex]} ';
        });
        wordIndex++;
      } else {
        timer.cancel();
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
            top: 130,
            left: 0,
            right: 0,
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

          // 풍선 이미지
          BalloonDisplay(
            balloonSize: 150, // 풍선 크기 조정
            // redBalloonOffset: Offset(50, 100), // 빨간 풍선 위치
            // yellowBalloonOffset: Offset(50, 200), // 노란 풍선 위치
          ),

          // 말풍선
          Positioned(
            top: 390,
            left: 20,
            right: 20,
            child: BalloonCard(
              content: _displayedText.isNotEmpty ? _displayedText : '...', // 현재까지 표시된 단어를 이어서 표시
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 간격 균등
                children: [
                  // 첫 번째 버튼: 다른 걱정 얘기하기
                  SizedBox(
                    width: 140,
                    height: 50,
                    child: WorryButton(
                      text: '첫화면으로',
                      onPressed: () {
                        // 버튼 동작 정의
                        _navigatorKey.currentState!.push(
                          MaterialPageRoute(builder: (context) => WorryDollHelloPage()),
                        );
                      },
                    ),
                  ),
                  // 두 번째 버튼: 다른 걱정 털어놓기
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: WorryButton(
                      text: '다른걱정 털어놓기',
                      onPressed: () {
                        // 버튼 동작 정의
                        _navigatorKey.currentState!.push(
                          MaterialPageRoute(builder: (context) => MyWorryPage()),
                        );
                      },
                      //backgroundColor: AppColors.blue, // 버튼 색상 변경
                    ),
                  ),
                ],
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
