import 'package:flutter/material.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';

class WorryDialog extends StatelessWidget {
  final DateTime time;
  final String worry;
  final String advice;
  final VoidCallback onPopBalloon;
  final Color backgroundColor; // 배경색 추가

  const WorryDialog({
    Key? key,
    required this.time,
    required this.worry,
    required this.advice,
    required this.onPopBalloon,
    this.backgroundColor = const Color(0xFFFFF0F0), // 기본 배경색 설정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        '오후 ${time.hour}시 ${time.minute}분',
        style: TextStyle(fontSize: 32),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 걱정 내용
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              worry,
              style: TextStyle(fontSize: 14),
            ),
          ),
          // 조언 내용
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              advice,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        // TextButton(
        //   onPressed: onPopBalloon,
        //   child: Text('걱정 풍선 터뜨리기', style: TextStyle(color: Colors.red)),
        // ),
        WorryButton(text: '걱정풍선 터뜨리기', onPressed: onPopBalloon),
      ],
    );
  }
}
