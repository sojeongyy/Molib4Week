import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class ResponsePage extends StatefulWidget {
  final String content;

  ResponsePage({required this.content});

  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  String _comfortMessage = '';
  String _displayedText = '';
  AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _textUpdateTimer;

  @override
  void initState() {
    super.initState();
    _sendToServer();  // 서버에 데이터 전송
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose(); // 오디오 플레이어 객체를 종료
    _textUpdateTimer?.cancel(); // 타이머 취소
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
        body: jsonEncode({'content': widget.content}),
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

  // TTS 생성 및 Polling
  Future<void> _generateTTS(String text) async {
    try {
      final url = "https://typecast.ai/api/speak";
      final payload = jsonEncode({
        "actor_id": "61532c5aed9bfa8b54d5dff6",
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
        print('Polling 중: $speakV2Url');
        final response = await http.get(Uri.parse(speakV2Url), headers: {
          'Authorization': 'Bearer ${dotenv.env['TYPECAST_API_KEY']}',
        });

        print('Polling 응답 상태 코드: ${response.statusCode}');
        print('Polling 응답 본문: ${response.body}');

        final responseJson = jsonDecode(response.body);
        if (responseJson['result']['status'] == 'done') {
          final audioUrl = responseJson['result']['audio_download_url'];
          if (audioUrl != null) {
            await _playAudio(audioUrl, comfortMessage);
            break;
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

  // 음성 파일 재생 및 UI 동기화
  Future<void> _playAudio(String url, String comfortMessage) async {
    final words = comfortMessage.split(' ');
    int wordIndex = 0;

    await _audioPlayer.play(UrlSource(url));
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _displayedText = comfortMessage;
      });
    });

    setState(() {
      _displayedText = '';
    });

    _textUpdateTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (wordIndex < words.length) {
        setState(() {
          _displayedText += '${words[wordIndex]} ';
        });
        wordIndex++;
      } else {
        timer.cancel();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("걱정 전달하기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '당신의 걱정:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '위로의 메시지:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _displayedText.isNotEmpty ? _displayedText : '...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
