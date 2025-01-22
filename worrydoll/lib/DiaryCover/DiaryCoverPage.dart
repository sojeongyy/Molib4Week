import 'package:flutter/material.dart';

class DiaryCoverPage extends StatelessWidget {
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
          Positioned(
            left: 90,
            top: 50,
            child: Image.asset(
              'assets/images/diary/rainbow.png',
              width: 100,
            ),
          ),

          // 손그림 이미지 2 - 악보
          Positioned(
            right: 60,
            top: 100,
            child: Image.asset(
              'assets/images/diary/music_note.png',
              width: 80,
            ),
          ),

          // 손그림 이미지 3 - 물방울
          Positioned(
            left: 70,
            bottom: 80,
            child: Image.asset(
              'assets/images/diary/raindrop.png',
              width: 90,
            ),
          ),

          // 손그림 이미지 4 - 연필
          Positioned(
            right: 60,
            bottom: 100,
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
                    fontFamily: 'baby',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '걱정일기',
                  style: TextStyle(
                    fontSize: 40,
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
