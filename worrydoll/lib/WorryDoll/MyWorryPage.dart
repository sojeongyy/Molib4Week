import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:worrydoll/WorryDoll/widgets/balloon_card.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ResponsePage.dart';


class MyWorryPage extends StatefulWidget {
  @override
  _MyWorryPageState createState() => _MyWorryPageState();
}

class _MyWorryPageState extends State<MyWorryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // stt
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';


  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 반복 시간
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복 (좌우로 흔들림)

    // 좌우 흔들림을 위한 Animation 설정 (각도 -0.05 ~ 0.05 라디안)
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // stt 초기화 및 녹음 시작
    _speech = stt.SpeechToText();
    _startListening();
  }

  @override
  void dispose() {
    _stopListening(); // 녹음 중지
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }
  // stt function
  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onError: (error) => print("STT Error: $error"),
      onStatus: (status) => print("STT Status: $status"),
    );
    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = "";
      });
      _speech.listen(
        onResult: (val) {
          setState(() {
            _recognizedText = val.recognizedWords;
          });
        },
        localeId: 'ko_KR',
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
      );
    } else {
      print("STT 초기화 실패");
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  // ui
  @override
  Widget build(BuildContext context) {
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
                  'assets/images/dolls/rabbit_shadow.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // 말풍선 카드(절대 위치, 고정 크기)
          Positioned(
            top: 390,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 305,
                height: 150,
                child: BalloonCard(
                  content: _recognizedText.isNotEmpty ? _recognizedText : '...',
                ),
              ),
            ),
          ),


          // 걱정 털어놓기 버튼(절대 위치, 고정 크기)
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
                  text: '걱정 전달하기',
                  onPressed: () async {
                    print('걱정 전달하기 버튼 클릭됨');
                    print(_recognizedText);
                    _stopListening();
                    // ResponsePage로 recognizedText를 전달
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResponsePage(content: _recognizedText),
                      ),
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
}

