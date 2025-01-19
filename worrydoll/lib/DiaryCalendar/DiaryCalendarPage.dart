import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../core/colors.dart';

class DiaryCalendarPage extends StatefulWidget {
  @override
  _DiaryCalendarPageState createState() => _DiaryCalendarPageState();
}

class _DiaryCalendarPageState extends State<DiaryCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // 부모 크기를 화면 전체로 설정
        height: double.infinity,
        color: AppColors.yellow,
        child: CustomPaint(
        painter: GridBackgroundPainter(), // 격자무늬 추가
        //color: AppColors.yellow,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          // 상단 제목
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 0, 20), // 위치 조정
            child: Text(
              '걱정일기 달력',
              style: TextStyle(
                fontFamily: 'baby', // 원하는 폰트 설정
                fontSize: 30,
                //fontWeight: FontWeight.bold,
                color: Colors.black, // 색상 설정
              ),
            ),
          ),
          // 캘린더
          Expanded(
            child: TableCalendar(
              locale: 'ko_KR', // 한국어로 설정
              firstDay: DateTime.utc(2000, 1, 1), // 캘린더 시작 날짜
              lastDay: DateTime.utc(2100, 12, 31), // 캘린더 끝 날짜
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // 캘린더가 현재 페이지를 유지
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: AppColors.pink,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.red),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false, // 월/주 보기 전환 버튼 숨김
                titleCentered: true,
                titleTextStyle:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // 버튼
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // 아래쪽 여백
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // 선택된 날짜로 특정 동작 수행
                  print('선택한 날짜: $_selectedDay');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('걱정일기 보러가기',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ),
        ],
        ),
        ),
      ),
    );
  }
}

class GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3) // 격자 색상 (반투명 흰색)
      ..strokeWidth = 1.0;

    const gridSize = 20.0; // 격자 간격

    // 세로선 그리기
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // 가로선 그리기
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}