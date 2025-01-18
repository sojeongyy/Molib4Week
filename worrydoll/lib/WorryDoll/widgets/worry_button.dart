import 'package:flutter/material.dart';

import '../../core/colors.dart';

class WorryButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  final String text;

  /// 버튼을 눌렀을 때 동작
  final VoidCallback onPressed;

  /// 버튼 배경색 (기본값: 분홍)
  final Color backgroundColor;

  /// 버튼 모서리 둥글기 (기본값: 16)
  final double borderRadius;

  /// 폰트 크기 (기본값: 18)
  final double fontSize;

  const WorryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.pink, // 분홍 계열 예시
    this.borderRadius = 20,
    this.fontSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 4.0,        // 버튼의 높이(그림자 강도)
        shadowColor: Colors.black,    // 그림자 색상
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: Colors.black),
      ),
    );
  }
}
