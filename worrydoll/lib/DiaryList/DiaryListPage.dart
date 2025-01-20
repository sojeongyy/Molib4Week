import 'package:flutter/material.dart';
import 'package:worrydoll/DiaryList/widgets/DiaryListComponent.dart';

import '../core/colors.dart';
import '../DiaryDetail/DiaryDetailPage.dart'; // DiaryDetailPage import

class DiaryListPage extends StatelessWidget {
  final DateTime selectedDate;

  const DiaryListPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.yellow,
        child: ListView(
          children: [
            const SizedBox(height: 50.0),
            Center(
              child: Text(
                '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 걱정일기',
                style: const TextStyle(
                  fontSize: 36.0,
                ),
              ),
            ),
            const SizedBox(height: 38.0),
            GestureDetector(
              onTap: () {
                // "오후 8:00" 시간과 해당 날짜를 DiaryDetailPage로 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryDetailPage(
                      dateTime: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        20, // 8시 (오후 8:00)
                        0, // 0분
                      ),
                    ),
                  ),
                );
              },
              child: const DiaryListComponent(
                time: '오후 8:00',
                content: '내일 가창시험이 걱정돼',
              ),
            ),
            GestureDetector(
              onTap: () {
                // "오후 9:00" 시간과 해당 날짜를 DiaryDetailPage로 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryDetailPage(
                      dateTime: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        21, // 9시 (오후 9:00)
                        0, // 0분
                      ),
                    ),
                  ),
                );
              },
              child: const DiaryListComponent(
                time: '오후 9:00',
                content: '애들이 날 피해ㅠㅠ',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
