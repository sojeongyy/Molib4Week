import 'package:flutter/material.dart';

import '../../core/colors.dart';

class BalloonCard extends StatelessWidget {
  /// 말풍선 안에 표시할 텍스트
  final String content;

  /// 말풍선 배경색 (기본값: 연한 크림색)
  final Color backgroundColor;

  /// 말풍선 모서리 둥글기 (기본값: 16)
  final double borderRadius;

  /// 폰트 크기 (기본값: 16)
  final double fontSize;

  const BalloonCard({
    Key? key,
    required this.content,
    this.backgroundColor = AppColors.yellow,
    this.borderRadius = 20.0,
    this.fontSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero, //
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 150,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16.0,
            offset: const Offset(0, 3), // 그림자를 약간 아래로
          ),
        ],
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.4,
          color: Colors.black87,
        ),
      ),
    );
  }
}
