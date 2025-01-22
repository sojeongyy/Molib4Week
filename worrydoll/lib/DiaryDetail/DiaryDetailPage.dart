import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/DollProvider.dart';
import '../core/colors.dart';

class DiaryDetailPage extends StatefulWidget {
  final int worryId;
  final DateTime dateTime;
  final String content; // 본문 내용
  final String comfortMessage; // 걱정인형의 한마디
  final String title;


  const DiaryDetailPage({
    Key? key,
    required this.worryId,
    required this.dateTime,
    required this.content,
    required this.comfortMessage,
    required this.title,
  }) : super(key: key);

  @override
  _DiaryDetailPageState createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  bool isEditing = false; // 편집 여부
  late String currentContent; // 수정 가능한 본문 내용
  final List<TextEditingController> controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<String> _splitContent(String content, int maxLength) {
    // 본문을 maxLength 기준으로 나누기
    List<String> result = [];
    for (int i = 0; i < content.length; i += maxLength) {
      result.add(content.substring(
          i, i + maxLength > content.length ? content.length : i + maxLength));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    currentContent = widget.content; // 초기값 설정
    // 본문 내용을 줄 단위로 나누어 초기화
    List<String> lines = _splitContent(currentContent, 27);
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].text = lines.length > i ? lines[i] : '';
    }
  }

  Future<void> updateWorryContent(int worryId, String newContent) async {
    await dotenv.load();
    final String baseUrl = dotenv.env['API_URL']!;
    final url = Uri.parse('$baseUrl$worryId');


    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"content": newContent}),
      );
      print('update worry url: $url');
      print(newContent);

      if (response.statusCode == 200) {
        // 서버가 업데이트 성공 응답을 보낸 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('내용이 성공적으로 저장되었습니다.')),
        );
      } else {
        // 서버 오류
        throw Exception('Failed to update content: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 또는 기타 예외 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    }
  }

  void _playComfortMessage() async {
    try {
      await _audioPlayer.play(AssetSource('audio/pop_sound.mp3')); // 변경해야됨
      // 음원 URL은 실제로 사용 가능한 URL로 교체하세요.
    } catch (e) {
      print('Audio playback error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final selectedDollName =
        Provider.of<DollProvider>(context).selectedDollName ?? "걱정인형"; // 선택되지 않았을 경우 기본 이미지
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          color: AppColors.yellow, // 배경색
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // 제목과 날짜/시간
              Text(
                '${widget.dateTime.year}년 ${widget.dateTime.month}월 ${widget.dateTime.day}일 시간: ${_formatTime(widget.dateTime)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'baby',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // 제목
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '제목: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'baby',
                      ),
                    ),
                  ),
                ],
              ),
              // const Divider(thickness: 1, color: Color(0xFFBFBBAC)),
              // 본문 영역
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    const Divider(thickness: 1, color: Color(0xFFBFBBAC)),
                    if (!isEditing)
                      Text(
                        controllers[i].text,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: 'baby',
                        ),
                      )
                    else
                      TextField(
                        controller: controllers[i],
                        focusNode: focusNodes[i],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: 'baby',
                        ),
                        maxLines: 1,
                        onChanged: (value) {
                          if (value.length > 27 && i < focusNodes.length - 1) {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[i + 1]);
                          }
                        },
                      ),
                  ],
                  const Divider(thickness: 1, color: Color(0xFFBFBBAC)),
                ],
              ),
              const SizedBox(height: 20),
              // 편집/저장 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (isEditing) {
                        // 편집 완료 시 컨텐츠 저장
                        setState(() {
                          currentContent = controllers
                              .map((controller) => controller.text)
                              .join('');
                        });
                        await updateWorryContent(widget.worryId, currentContent);
                      }
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isEditing ? '저장' : '편집',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 걱정인형의 한마디
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '걱정인형의 한마디',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {
                      _playComfortMessage();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  widget.comfortMessage,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '- ' + selectedDollName,
                  style: const TextStyle(
                    fontSize: 20,
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
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? '오후' : '오전';
    return '$period $hour:$minute';
  }
}
