import 'package:flutter/material.dart';

import '../../core/colors.dart';

class ConfirmDollDialog extends StatelessWidget {
  final String dollName;
  final String dollImagePath;
  final VoidCallback onConfirm;

  const ConfirmDollDialog({
    Key? key,
    required this.dollName,
    required this.dollImagePath,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.pink,
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0), // 이미지를 밑으로 이동
              child: ClipOval(
                child: Image.asset(
                  dollImagePath,
                  fit: BoxFit.contain,
                  //width: 200, // 이미지 크기 조정
                  // height: 90,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$dollName이를 선택하시겠습니까?',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                child: const Text(
                  '아니요',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm(); // 확인 동작 실행
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                child: const Text(
                  '네',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
