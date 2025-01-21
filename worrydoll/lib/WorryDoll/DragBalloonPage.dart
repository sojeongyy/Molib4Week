import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/DollProvider.dart';

class DragBalloonPage extends StatefulWidget {
  @override
  _DragBalloonPageState createState() => _DragBalloonPageState();
}

class _DragBalloonPageState extends State<DragBalloonPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDropped = false; // 풍선이 드롭되었는지 확인

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 반복 시간
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복 (좌우로 흔들림)

    // 좌우 흔들림을 위한 Animation 설정
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    // 선택된 인형 이미지 경로 가져오기
    final selectedDollImagePath =
        Provider.of<DollProvider>(context).selectedDollImagePath ??
            'assets/images/dolls/default.png'; // 선택되지 않았을 경우 기본 이미지

    final selectedDollName =
        Provider.of<DollProvider>(context).selectedDollName ?? "걱정인형"; // 선택되지 않았을 경우 기본 이미지

    return Scaffold(
      body: Stack(
        children: [
          // 배경
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 인형
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: DragTarget<String>(
              onAccept: (data) {
                if (data == "balloon") {
                  setState(() {
                    _isDropped = true;
                  });
                  // 다음 화면으로 이동
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NextScreen()),
                    );
                  });
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Align(
                  alignment: Alignment.topCenter, // 수평 중앙
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.bottomCenter, // 엉덩이 고정
                        transform: Matrix4.rotationZ(_animation.value), // 좌우 흔들림
                        child: Column(
                          children: [
                            Image.asset(
                              selectedDollImagePath,
                              height: 170,
                              fit: BoxFit.contain,
                            ),
                            // if (_isDropped)
                            //   const Text(
                            //     '감사합니다!',
                            //     style: TextStyle(
                            //       fontSize: 18,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // 풍선
          Positioned(
            bottom: 150,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Draggable<String>(
              data: "balloon",
              feedback: Material( // 드래그 중 풍선 이미지
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/balloons/red_balloon.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/balloons/red_balloon.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              child: Image.asset(
                'assets/images/balloons/red_balloon.png',
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 하단 텍스트
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '걱정 풍선을 건네주세요',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '다음 화면으로 이동했습니다!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
