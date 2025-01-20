import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // JSON 파일 로드용
import 'package:worrydoll/DiaryList/widgets/DiaryListComponent.dart';

import '../core/colors.dart';
import '../DiaryDetail/DiaryDetailPage.dart'; // DiaryDetailPage import

class DiaryListPage extends StatefulWidget {
  final DateTime selectedDate;

  const DiaryListPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _DiaryListPageState createState() => _DiaryListPageState();
}

class _DiaryListPageState extends State<DiaryListPage> {
  List<Map<String, dynamic>> diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDiaryEntries();
  }

  Future<void> _loadDiaryEntries() async {
    // JSON 파일 로드
    final String response =
    await rootBundle.loadString('assets/json/diary_dummy_data.json');
    final List<dynamic> data = json.decode(response);

    // selectedDate와 일치하는 데이터 필터링
    final filteredData = data.where((entry) {
      final entryDate = DateTime.parse(entry['date_created']);
      return entryDate.year == widget.selectedDate.year &&
          entryDate.month == widget.selectedDate.month &&
          entryDate.day == widget.selectedDate.day;
    }).toList();

    setState(() {
      diaryEntries = filteredData.cast<Map<String, dynamic>>();
    });
  }

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
                '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일 걱정일기',
                style: const TextStyle(
                  fontSize: 36.0,
                ),
              ),
            ),
            const SizedBox(height: 38.0),
            if (diaryEntries.isEmpty)
              const Center(
                child: Text(
                  '선택된 날짜에 걱정일기가 없습니다.\n행복한 하루셨나봐요!',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            else
              ...diaryEntries.map((entry) {
                final entryTime = DateTime.parse(entry['date_created']);
                return GestureDetector(
                  onTap: () {
                    // 선택한 일기의 상세 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryDetailPage(
                          dateTime: entryTime,
                        ),
                      ),
                    );
                  },
                  child: DiaryListComponent(
                    time:
                    '${entryTime.hour > 12 ? "오후" : "오전"} ${entryTime.hour % 12}:${entryTime.minute.toString().padLeft(2, '0')}',
                    content: entry['content'],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
