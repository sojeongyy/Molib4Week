import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDiaryEntries();
  }

  Future<void> _loadDiaryEntries() async {
    await dotenv.load();
    final String baseUrl = dotenv.env['API_URL']!;
    final String formattedDate =
        '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';

    try {
      final response = await http.get(Uri.parse('$baseUrl?date=$formattedDate'));
      print('$baseUrl?date=$formattedDate');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedBody);

        setState(() {
          diaryEntries = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = '데이터를 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = '데이터를 불러오는 중 오류가 발생했습니다: $e';
      });
    }
  }

  DateTime _convertToKST(DateTime utcTime) {
    return utcTime.add(const Duration(hours: 9)); // UTC에 +9시간을 더해 KST로 변환
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
                '${_convertToKST(widget.selectedDate).year}년 ${_convertToKST(widget.selectedDate).month}월 ${_convertToKST(widget.selectedDate).day}일 걱정일기',
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
                final entryKST = _convertToKST(entryTime);
                return GestureDetector(
                  onTap: () {
                    // 선택한 일기의 상세 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryDetailPage(
                          worryId: entry['id'],
                          dateTime: entryKST,
                          content: entry['content'],
                          comfortMessage: entry['comfort_message'] ?? '',
                          title: entry['title'],
                        ),
                      ),
                    );
                  },
                  child: DiaryListComponent(
                    time:
                    '${entryKST.hour > 12 ? "오후" : "오전"} ${entryKST.hour % 12}:${entryKST.minute.toString().padLeft(2, '0')}',
                    title: entry['title'],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
