import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';
import 'package:worrydoll/core/colors.dart';

import '../../core/DollProvider.dart';

class WorryDialog extends StatelessWidget {
  final DateTime time;
  final String worry;
  final String advice;
  final VoidCallback onPopBalloon;
  final Color backgroundColor; // 배경색 추가
  final Color buttonColor; // 버튼 색상 추가

  const WorryDialog({
    Key? key,
    required this.time,
    required this.worry,
    required this.advice,
    required this.onPopBalloon,
    this.backgroundColor = const Color(0xFFFFF0F0), // 기본 배경색 설정
    this.buttonColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final selectedDollName =
        Provider.of<DollProvider>(context).selectedDollName ?? "걱정인형"; // 선택되지 않았을 경우 기본 이미지

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
              advice + ' -$selectedDollName',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        WorryButton(text: '걱정풍선 터뜨리기', onPressed: onPopBalloon, backgroundColor: buttonColor, fontColor: Colors.black),
      ],
    );
  }
}
