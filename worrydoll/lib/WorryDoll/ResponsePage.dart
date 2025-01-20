import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResponsePage extends StatefulWidget {
  final String content;

  ResponsePage({required this.content});

  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  String _comfortMessage = '';

  @override
  void initState() {
    super.initState();
    _sendToServer();  // 서버에 데이터 전송
  }

  Future<void> _sendToServer() async {
    await dotenv.load();
    final apiUrl = dotenv.env['API_URL']!;  // 스트리밍 URL

    if (apiUrl == null || apiUrl.isEmpty) {
      setState(() {
        _comfortMessage = 'API URL이 설정되지 않았습니다.';
      });
      return;
    }

    try {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse(apiUrl))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({'content': widget.content});

      final response = await client.send(request);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _listenToStream(response.stream); // 응답 스트리밍 처리
      } else {
        setState(() {
          _comfortMessage = "전송 실패: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _comfortMessage = "서버 전송 중 오류 발생: $e";
      });
    }
  }

  void _listenToStream(Stream<List<int>> stream) {
    final responseString = StringBuffer();

    stream.listen(
          (List<int> chunk) {
        final chunkStr = utf8.decode(chunk);
        setState(() {
          responseString.write(chunkStr);
          _comfortMessage = responseString.toString();  // 스트리밍 데이터를 실시간으로 업데이트
        });
      },
      onDone: () {
        // 스트리밍 완료 시, 별도의 처리 없이 데이터를 계속 표시
      },
      onError: (error) {
        setState(() {
          _comfortMessage = "스트리밍 중 오류 발생: $error";
        });
      },
    );
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
            Column(
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
                  _comfortMessage.isNotEmpty ? _comfortMessage : '...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
