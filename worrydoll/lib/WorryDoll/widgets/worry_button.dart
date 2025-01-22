import 'package:flutter/material.dart';

import '../../core/colors.dart';

class WorryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final double fontSize;
  final Color fontColor;

  const WorryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.pink, // 분홍 계열 예시
    this.borderRadius = 20,
    this.fontSize = 18.0,
    this.fontColor = Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 20), // 버튼 내부 padding
        elevation: 4.0,        // 버튼의 높이(그림자 강도)
        shadowColor: Colors.black,    // 그림자 색상
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: fontColor),
      ),
    );
  }
}
