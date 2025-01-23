import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/WorryDoll/WorryingPage.dart';

import '../core/DollProvider.dart';

class DragBalloonPage extends StatefulWidget {

  final String content;

  DragBalloonPage({required this.content});

  @override
  _DragBalloonPageState createState() => _DragBalloonPageState();
}

class _DragBalloonPageState extends State<DragBalloonPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDropped = false; // 풍선이 드롭되었는지 확인
  String _comfortMessage = '';
  String _displayedText = '';
  String _audioUrl = ''; // 오디오 URL
  int _balloonType = 1; // 1: red, 2: yellow, 3: blue
  String _balloonColor = 'red'; // 기본값 red


  @override
  void initState() {
    super.initState();
    _selectRandomBalloon();
    _sendToServer();  // 서버에 데이터 전송
    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 반복 시간
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복 (좌우로 흔들림)

    // 좌우 흔들림을 위한 Animation 설정
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }

  /// 랜덤 풍선 색상 선택
  void _selectRandomBalloon() {
    final random = Random();
    final balloonOptions = [
      {'color': 'red', 'type': 1},
      {'color': 'yellow', 'type': 2},
      {'color': 'blue', 'type': 3},
    ];

    final selected = balloonOptions[random.nextInt(balloonOptions.length)];
    setState(() {
      _balloonColor = selected['color'] as String;
      _balloonType = selected['type'] as int;
    });
    print('Selected Balloon: $_balloonColor ($_balloonType)');
  }

  Future<void> _sendToServer() async {
    await dotenv.load();
    final apiUrl = dotenv.env['API_URL']!;  // Get Comfort message URL

    print(apiUrl);
    if (apiUrl == null || apiUrl.isEmpty) {
      setState(() {
        _comfortMessage = 'API URL이 설정되지 않았습니다.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': widget.content, 'balloon_color' : _balloonColor}),
      );
      print('응답 상태 코드: ${response.statusCode}');
      print('응답 본문: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final comfortMessage = responseData['comfort_message'];
        print('응답 데이터: $responseData');

        if (comfortMessage.isNotEmpty) {
          setState(() {
            _comfortMessage = comfortMessage;
          });
          await _generateTTS(comfortMessage); // TTS 생성 및 Polling 시작
        }
      } else {
        setState(() {
          _comfortMessage = "전송 실패: ${response.statusCode}";
          print(_comfortMessage);
        });
      }
    } catch (e) {
      setState(() {
        _comfortMessage = "서버 전송 중 오류 발생: $e";
        print(_comfortMessage);
      });
    }
  }

  final Map<String, String> actorIdMapping = {
    '토순': '660637108db3e2c06ff6ffa7', // 예: '토끼 인형'에 해당하는 ID
    '곰돌': '618203826672d21ebf37748e', // 덕구
    '길인': '61532cab9119555d352f5c69', // 팡팡
    '어흥': '5ebea13564afaf00087fc2e7',  // 틸
    '개굴': '61532c5aed9bfa8b54d5dff6',  // 아봉
    '늘봉': '5ebea13564afaf00087fc2e7',  // 영길
  };

  // TTS 생성 및 Polling
  Future<void> _generateTTS(String text) async {
    try {

      final selectedDollName =
          Provider.of<DollProvider>(context, listen: false).selectedDollName ??
              "기본 인형";

      final url = "https://typecast.ai/api/speak";
      // actor_id 설정
      final actorId = actorIdMapping[selectedDollName] ??
          '61532c5aed9bfa8b54d5dff6'; // 기본 actor_id 설정
      final payload = jsonEncode({
        "actor_id": actorId,
        "text": text,
        "lang": "auto",
        "xapi_hd": true,
        "model_version": "latest",
        "xapi_audio_format": "wav"
      });


      final apiKey = dotenv.env['TYPECAST_API_KEY']!;
      print('API Key: ${dotenv.env['TYPECAST_API_KEY']}');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      print('TTS 요청 URL: $url');
      print('TTS 요청 Payload: $payload');

      final response = await http.post(Uri.parse(url), headers: headers, body: payload);
      print('TTS 응답 상태 코드: ${response.statusCode}');
      print('TTS 응답 본문: ${response.body}');
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final speakV2Url = responseBody['result']['speak_v2_url'];

        if (speakV2Url != null) {
          await _pollForAudioUrl(speakV2Url, text);
        } else {
          setState(() {
            _comfortMessage = "TTS 생성 실패: speak_v2_url이 반환되지 않았습니다.";
            print(_comfortMessage);
          });
        }
      } else {
        setState(() {
          _comfortMessage = "TTS 요청 실패: ${response.statusCode}";
          print(_comfortMessage);
        });
      }
    } catch (e) {
      setState(() {
        _comfortMessage = "TTS 생성 중 오류 발생: $e";
        print(_comfortMessage);
      });
    }
  }

// Polling으로 Audio URL 획득
  Future<void> _pollForAudioUrl(String speakV2Url, String comfortMessage) async {
    const pollingInterval = Duration(seconds: 1);

    while (true) {
      try {
        //print('Polling 중: $speakV2Url');
        final response = await http.get(Uri.parse(speakV2Url), headers: {
          'Authorization': 'Bearer ${dotenv.env['TYPECAST_API_KEY']}',
        });

        //print('Polling 응답 상태 코드: ${response.statusCode}');
        //print('Polling 응답 본문: ${response.body}');

        final responseJson = jsonDecode(response.body);
        if (responseJson['result']['status'] == 'done') {
          final audioUrl = responseJson['result']['audio_download_url'];
          if (audioUrl != null) {
            setState(() {
              _audioUrl = audioUrl; // 오디오 URL 저장
              _comfortMessage = comfortMessage; // 조언 메시지 저장
            });
            // await _playAudio(audioUrl, comfortMessage);
            // break;
          }
        } else if (responseJson['result']['status'] == 'error') {
          setState(() {
            _comfortMessage = "오디오 생성 중 오류 발생.";
            print(_comfortMessage);
          });
          break;
        }
      } catch (e) {
        setState(() {
          _comfortMessage = "Polling 중 오류 발생: $e";
          print(_comfortMessage);
        });
        break;
      }
      await Future.delayed(pollingInterval);
    }
  }

  @override
  Widget build(BuildContext context) {

    // 선택된 인형 이미지 경로 가져오기
    final selectedDollImagePath =
        Provider.of<DollProvider>(context).selectedDollImagePath ??
            'assets/images/dolls/default.png'; // 선택되지 않았을 경우 기본 이미지

    final selectedDollName =
        Provider.of<DollProvider>(context).selectedDollName ?? "걱정인형"; // 선택되지 않았을 경우 기본 이미지

    final balloonCount = Provider.of<DollProvider>(context).balloonCount;

    // 풍선 이미지 경로 결정

    final balloonImagePath = 'assets/images/balloons/${_balloonColor}_balloon.png';

    return Scaffold(
      body: Stack(
        children: [
          // 배경
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 인형
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: DragTarget<String>(
              onAccept: (data) {
                if (data == "balloon") {
                  setState(() {
                    _isDropped = true;
                  });
                  Provider.of<DollProvider>(context, listen: false).addBalloon();
                  // 다음 화면으로 이동
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WorryingPage(
                        audioUrl: _audioUrl,
                        comfortMessage: _comfortMessage,
                      ),),
                    );
                  });
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Align(
                  alignment: Alignment.topCenter, // 수평 중앙
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.bottomCenter, // 엉덩이 고정
                        transform: Matrix4.rotationZ(_animation.value), // 좌우 흔들림
                        child: Column(
                          children: [
                            Image.asset(
                              selectedDollImagePath,
                              height: 170,
                              fit: BoxFit.contain,
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // 풍선
          Positioned(
            bottom: 150,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Draggable<String>(
              data: "balloon",
              feedback: Material( // 드래그 중 풍선 이미지
                color: Colors.transparent,
                child: Image.asset(
                    balloonImagePath,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              // childWhenDragging: Opacity(
              //   opacity: 0.5,
              //   child: Image.asset(
              //     balloonImagePath,
              //     height: 150,
              //     fit: BoxFit.contain,
              //   ),
              // ),
              child: Image.asset( // 드래그 전 풍선 이미지
                balloonImagePath,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 하단 텍스트
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '걱정 풍선을 건네주세요',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
