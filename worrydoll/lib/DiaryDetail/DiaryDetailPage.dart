import 'package:flutter/material.dart';

import '../core/colors.dart';

class DiaryDetailPage extends StatelessWidget {
  final DateTime dateTime;

  const DiaryDetailPage({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        color: AppColors.yellow, // 배경색 (연노란색)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // 제목과 날짜/시간
            Text(
              '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 시간: ${_formatTime(dateTime)}',
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'baby',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '제목:',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFBFBBAC)),
            // 일기 내용 작성 (줄글 스타일)
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    TextField(
                      decoration: const InputDecoration(
                        // hintText: '내용을 입력하세요.',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      maxLines: 1, // 한 줄 입력
                    ),
                    if (i != 4)
                      const Divider(
                        thickness: 1,
                        color: Color(0xFFBFBBAC),
                      ),
                  ],
                ],
              ),
            const SizedBox(height: 40),
            const Text(
              '걱정인형의 한마디',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     blurRadius: 10,
                //     offset: const Offset(0, 4),
                //   ),
                // ],
              ),
              child: const Text(
                '지금 많이 힘들겠지만, 너무 애쓰지 않아도 괜찮아. 네가 할 수 있는 만큼만 해도 충분해!',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '- 토순이가',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    // 시간 포맷팅 (오전/오후 12시간제)
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? '오후' : '오전';
    return '$period $hour:$minute';
  }
}
