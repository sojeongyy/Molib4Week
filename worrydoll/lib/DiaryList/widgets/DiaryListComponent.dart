import 'package:flutter/material.dart';

import '../../core/colors.dart';

class DiaryListComponent extends StatelessWidget {
  final String time;
  final String title;

  const DiaryListComponent({
    Key? key,
    required this.time,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      padding: const EdgeInsets.all(16.0),
      height: 87, // 높이를 고정
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상과 투명도
            blurRadius: 10, // 흐림 정도
            offset: Offset(0, 4), // 그림자의 위치 (x, y)
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              // 글씨 색상 흰색
              color: Colors.white,
              //backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 32.0),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: 'baby',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
