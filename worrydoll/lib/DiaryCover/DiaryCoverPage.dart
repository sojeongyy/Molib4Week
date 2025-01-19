import 'dart:math';

import 'package:flutter/material.dart';

class DiaryCoverPage extends StatefulWidget {
  @override
  _DiaryCoverPageState createState() => _DiaryCoverPageState();
}

class _DiaryCoverPageState extends State<DiaryCoverPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation1;
  // late Animation<double> _animation2;
  // late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 20), // 짧은 애니메이션 지속 시간
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 전체 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/diary_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // 손그림 이미지 1 - 무지개
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final random = Random();
              final offset = random.nextBool() ? 20.0 : -20.0; // 순간이동 느낌
              return Positioned(
                left: 90 + offset,
                top: 50,
                child: child!,
              );
            },
            child: Image.asset(
              'assets/images/diary/rainbow.png',
              width: 100,
            ),
          ),

          // 손그림 이미지 2 - 악보
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final random = Random();
              final offset = random.nextBool() ? 15.0 : -15.0; // 순간이동 느낌
              return Positioned(
                right: 90 + offset,
                top: 100,
                child: child!,
              );
            },
            child: Image.asset(
              'assets/images/diary/music_note.png',
              width: 80,
            ),
          ),


          // 손그림 이미지 3 - 물방울
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final random = Random();
              final offset = random.nextBool() ? 10.0 : -10.0; // 순간이동 느낌
              return Positioned(
                left: 70 + offset,
                bottom: 80,
                child: child!,
              );
            },
            child: Image.asset(
              'assets/images/diary/raindrop.png',
              width: 90,
            ),
          ),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final random = Random();
              final offset = random.nextBool() ? 10.0 : -10.0; // 순간이동 느낌
              return Positioned(
                right: 70 + offset,
                bottom: 100,
                child: child!,
              );
            },
            child: Image.asset(
              'assets/images/diary/pencil.png',
              width: 90,
            ),
          ),

          // 가운데 텍스트
          Positioned(
            top: 250,
            left: 117,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '2025',
                  style: TextStyle(
                    fontSize: 40,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'baby',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '걱정일기',
                  style: TextStyle(
                    fontSize: 40,
                    //fontWeight: FontWeight.w400,
                    fontFamily: 'baby',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
