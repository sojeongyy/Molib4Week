import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/WorryDoll/MyWorryPage.dart';
import 'package:worrydoll/WorryDoll/WorryDollHelloPage.dart';
import 'package:worrydoll/WorryDoll/widgets/BalloonDisplay.dart';
import 'package:worrydoll/WorryDoll/widgets/balloon_card.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';

import '../core/DollProvider.dart';
import '../core/colors.dart';
import 'DragBalloonPage.dart';


class WorryingPage extends StatefulWidget {
  final String audioUrl;
  final String comfortMessage;
  final String balloonColor;

  WorryingPage({required this.audioUrl, required this.comfortMessage, required this.balloonColor});

  @override
  _WorryingPageState createState() => _WorryingPageState();
}

class _WorryingPageState extends State<WorryingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late String firstMessage;
  final String secondMessage = "이 걱정은 내가 짊어질테니 이제 푹 쉬어. 좋은 꿈 꿔!";
  bool _isSecondMessagePlaying = false;

  AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _textUpdateTimer;

  List<String> _displayedWords = [];
  int _currentWordIndex = 0;
  bool _showFirstMessage = true;
  Timer? _timer;
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    firstMessage = widget.comfortMessage;
    _playAudio(widget.audioUrl, firstMessage);
    //_startTypingEffect(firstMessage);

    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 반복 시간
      vsync: this,
    )
      ..repeat(reverse: true); // 애니메이션 반복 (좌우로 흔들림)

    // 좌우 흔들림을 위한 Animation 설정 (각도 -0.05 ~ 0.05 라디안)
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }

  void _startTypingEffect(String message) {
    _timer?.cancel(); // 기존 타이머 취소
    List<String> words = message.split(' '); // 메시지를 단어별로 나누기
    _displayedWords = [];
    _currentWordIndex = 0;

    _timer =
        Timer.periodic(Duration(milliseconds: 300), (timer) { // 이걸로 속도 조정 가능!
          if (_currentWordIndex < words.length) {
            setState(() {
              _displayedWords.add(words[_currentWordIndex]);
              _currentWordIndex++;
            });
          } else {
            timer.cancel(); // 모든 단어가 표시되면 타이머 중지
            if (_showFirstMessage) {
              // 첫 번째 메시지가 끝난 후 두 번째 메시지로 전환
              Future.delayed(Duration(milliseconds: 500), () {
                //_switchToSecondMessage();
                _isSecondMessagePlaying = true;
              });
            }
          }
        });
  }

  Future<void> _playAudio(String url, String comfortMessage) async {
    if (_isSecondMessagePlaying) {
      print('Audio is already playing. Ignoring this call.');
      return;
    }

    final words = comfortMessage.split(' ');
    int wordIndex = 0;

    await _audioPlayer.play(UrlSource(url));
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _displayedText = comfortMessage;
      });

      // 오디오 재생이 끝난 후 두 번째 메시지로 전환
      _switchToSecondMessage();
      _isSecondMessagePlaying = true;
    });
    //_isSecondMessagePlaying = false;
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
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _buildWorryingPage(context),
        );
      },
    );
  }

  Widget _buildWorryingPage(BuildContext context) {
    final selectedDollImagePath =
        Provider
            .of<DollProvider>(context)
            .selectedDollImagePath ??
            'assets/images/dolls/default.png'; // 선택되지 않았을 경우 기본 이미지

    // 풍선 이미지 경로 결정
    final balloonImagePath = 'assets/images/balloons/${widget.balloonColor}_balloon.png';

    return Scaffold(
      body: Stack(
        children: [
          // 전체 배경
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 토끼 인형 이미지(절대 위치, 고정 크기)
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter, // 수평 중앙
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.bottomCenter, // 엉덩이 고정
                    transform: Matrix4.rotationZ(_animation.value), // 좌우 흔들림
                    child: child,
                  );
                },
                child: Image.asset(
                  selectedDollImagePath,
                  width: 170,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // // 풍선 이미지
          // BalloonDisplay(
          //   balloonSize: 150, // 풍선 크기 조정
          //   // redBalloonOffset: Offset(50, 100), // 빨간 풍선 위치
          //   // yellowBalloonOffset: Offset(50, 200), // 노란 풍선 위치
          // ),

          // 말풍선
          Positioned(
            top: 390,
            left: 20,
            right: 20,
            child: BalloonCard(
              content: _displayedText.isNotEmpty
                  ? _displayedText
                  : '...', // 현재까지 표시된 단어를 이어서 표시
            ),
          ),

          // 풍선 이미지 추가
          Positioned(
            top: 130, // 풍선 Y 위치
            right: 50, // 풍선 X 위치 (화면 중앙)
            child: Image.asset(
              balloonImagePath,
              width: 90,
              fit: BoxFit.contain,
            ),
          ),

          // 걱정 털어놓기 버튼(절대 위치, 고정 크기)
          if (!_showFirstMessage)
            Positioned(
              top: 570,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 간격 균등
                  children: [
                    // 첫 번째 버튼: 다른 걱정 얘기하기
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: WorryButton(
                        text: '첫화면으로',
                        onPressed: () {
                          // 버튼 동작 정의
                          _navigatorKey.currentState!.push(
                            MaterialPageRoute(
                                builder: (context) => WorryDollHelloPage()),
                          );
                        },
                      ),
                    ),
                    // 두 번째 버튼: 다른 걱정 털어놓기
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: WorryButton(
                        text: '다른걱정 털어놓기',
                        onPressed: () {
                          // 버튼 동작 정의
                          _navigatorKey.currentState!.push(
                            MaterialPageRoute(
                                builder: (context) => MyWorryPage()),
                          );
                        },
                        //backgroundColor: AppColors.blue, // 버튼 색상 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  final Map<String, String> MapSecondMessages = {
    '토순': 'https://cdn.typecast.ai/data/s/2025/1/22/light-speakcore-worker-7cbf478964-47wp4/6df2d3bd-34ad-4dd3-be89-11681047fe44.wav?Expires=1737631152&Signature=rSGHdpkHX3KSijrFlbRC-Zqbl7U1w7Q7GEsSaWnTUVyaGJyHvzSetiQt5qXAK9cXRTwds6KwGZISviWxxrbff6fNVHFESrY6tG0hf307p-fLG78mvwe89mFu7kP6gH-m3P4FOSuwH7acBrpHYh7yKC5DuTjoX75ZXtKSxcK7tr9Hn3eq6DNAOBsRnA2REpb6JM7XEwjQ~XbfgFh48EqrGGmNzXNcgHgRltdQAhGIRavAxgBK4qQ4QWOYmBhkKm5S03mBizcRmWl1IX630YlpqidM7qSmL-HYf3mntLmKxQwgMmnx8Jo-ClX6J6ImfTesUSzvlOfxpqNNfJyUh2IMLw__&Key-Pair-Id=K11PO7SMLJYOIE', // 예: '토끼 인형'에 해당하는 ID
    '곰돌': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-7f5b66db69-cp75q/7cdc3a4b-318a-4a4c-9eae-97ae096a7b8b.wav?Expires=1737700969&Signature=ppQum9vDJeVlmh46AuE~dkbNn6b5XxB5~GSsB4mNAP7oA~CYR8MBRxAZ~K9hnFC7C4k7hGpKlpslL88j52y2gWtqpsvsMVjDpTtCIM-rnWMPGb8-qduTcWoab8iNNDtFfjAXvPTWqyXE~UA7GBzG6YDBj8nKQ6SGxRgtgZYSiJe8y9tkVeFcGNUgXddjuucza6Y1DjKXISmhBM9AqQ9Ep-LbOrjv8YthvqcBx-WTSBXhMfz~f5cy5sckch0QpROdmk8RA5eGP6qjwULcEgnMchyatB71Hs4V3alHBgqtJ5xPsl35KG4MkYLlE3vPEd6nNpw0cq9FfewNjKe~946YKA__&Key-Pair-Id=K11PO7SMLJYOIE', // 덕구
    '길인': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-7f5b66db69-cp75q/52576707-800d-452e-8c81-577c89a17b7b.wav?Expires=1737701105&Signature=Hp4Na649d8FkMjDkYLkaH6VkwjF-FgG6DN7baxRXHV8IYZJq8RHcxmU0Y18NcK~5MBBeEzAXxm7eH~ykmRhB~HFJMsd0sjaisrhZbrlOggIiz9WPPiOmrB9LfmQKRiW-le5uolsoCCweaUgEPyjSttUezpSfzhAxZh2OX36rudYWAJDD-p3Rxqs~YhnD9yrkpg~IrjL-cFGjVvY3JIrM1I6p-s9RXe3hSigga3QnuTBBTo6u8CAj-oWVDvcVFcGfrDgynSXwLu7WwACNsbQ9s51r0HUx~dX5iyj~oVdrIQTlpHzxThXGuFthvs4F1ZWBaFyMXdRKgCkgtQUojefyow__&Key-Pair-Id=K11PO7SMLJYOIE', // 팡팡
    '어흥': 'https://cdn.typecast.ai/data/s/2025/1/22/light-speakcore-worker-7cbf478964-hf7kc/317d7fd9-f71a-4365-8234-51747b85368f.wav?Expires=1737630580&Signature=drBA2ARuGR4YPbLkcvMh6xdzsT3IDtCOr5DCj1qqqrqllXmfKQCL8JF55qNEQ42OAkxL~hOv9geMNPLZIviiyuW-ww4l9n0WtMy9lCFhLR15yDEt~-ELI5pyUHF-37FIO3oTu4pghwyK0OEkTFxJWskS1AUb8Jp-Fe6wGLi0KDrM3-X9aEVoiN2bF5W5NqIYEAQM-S9xf4BkKS4gKJLuAsS1OlILMWfX4sb-9OSPZDt2zMABTiZcLsf61JK0MqJB6cpGZ34MePYpa438Xfk1qZIcSSOV3G-P-Ts-m3y2GjzftNEw-GRQZ9-3f9sCDNQbjId9XS6TpOUMtD0K1CVohA__&Key-Pair-Id=K11PO7SMLJYOIE',  // 틸
    '개굴': '61532c5aed9bfa8b54d5dff6',  // 아봉
    '늘봉': '5ebea13564afaf00087fc2e7',  // 영길
  };
  void _switchToSecondMessage() {
    print('Switching to the second message');
    print('isSecondMessagePlaying: $_isSecondMessagePlaying');
    if (_isSecondMessagePlaying) return;
    setState(() {
      _showFirstMessage = false;
      _displayedText = '';
      //_isSecondMessagePlaying = true; // 재생 상태 업데이트
    });
    //_startTypingEffect(secondMessage); // 글자
    final selectedDollName =
        Provider.of<DollProvider>(context, listen: false).selectedDollName ??
            "기본 인형";
    print(selectedDollName);

    String url = MapSecondMessages[selectedDollName] ??
        'https://cdn.typecast.ai/data/s/2025/1/22/light-speakcore-worker-6f9979d5f6-xkg4p/088fe74b-3851-4084-a2a4-015ce42a61b8.wav?Expires=1737614904&Signature=sa0b09jNp30hr7TNiy7LazCmJOGx30854jMznzwKtkJg4SQU0~FtkGOFB1OJgXtK781jbBybkLqVRXrZmeGrXSY6AZTJhnc84o1sCrHyQ7j38ZCbheejMd1EHFnBaCFE6s3lRMmo1Uc1VXDzgl6XMN4gQ9iKfLDmqRKPpvaWWj4KK5BUqMV6hrPFdDr6SDqHY9RZhbweFjfD-J~Y1iLd4Ya00Zjmtt-UOBz7ZxztDXJd-3qbbIvfeFO5b8bYFo5MqIcxl~nwrelhi4aC9mBbqLhInbeY06jj9SUXbBZUlXl7EWsZn0PQjvW0gsC-3gg4Jo~lF9TjgzwMkcVal~uBIQ__&Key-Pair-Id=K11PO7SMLJYOIE'; // 기본 actor_id 설정
    _playAudio(url, secondMessage).then((_) {
      // 재생이 완료되면 상태 초기화
      setState(() {
        _isSecondMessagePlaying = true;
      });
    }).catchError((error) {
      // 오류 발생 시 상태 초기화
      setState(() {
        _isSecondMessagePlaying = true;
      });
      print('Error while playing second message: $error');
    });
  }
}