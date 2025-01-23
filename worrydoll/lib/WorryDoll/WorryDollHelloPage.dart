import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/WorryDoll/widgets/BalloonDisplay.dart';
import 'package:worrydoll/WorryDoll/widgets/balloon_card.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';
import 'package:audioplayers/audioplayers.dart';

import '../core/DollProvider.dart';
import 'MyWorryPage.dart';

class WorryDollHelloPage extends StatefulWidget {
  @override
  _WorryDollHelloPageState createState() => _WorryDollHelloPageState();
}

class _WorryDollHelloPageState extends State<WorryDollHelloPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playWelcomeMessage();

    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 반복 시간
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복 (좌우로 흔들림)

    // 좌우 흔들림을 위한 Animation 설정 (각도 -0.05 ~ 0.05 라디안)
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }

  // 페이지 로드 시 오디오 재생
  Future<void> _playWelcomeMessage() async {
    final selectedDollName =
        Provider.of<DollProvider>(context, listen: false).selectedDollName ??
            "걱정인형"; // 선택된 인형 이름 가져오기
    final audioUrl = MapFirstMessgaes[selectedDollName]; // 해당 인형의 URL 가져오기

    if (audioUrl != null && audioUrl.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(audioUrl)); // URL 오디오 재생
        print("재생 중인 URL: $audioUrl");
      } catch (e) {
        print("오디오 재생 오류: $e");
      }
    } else {
      print("해당 인형에 URL이 없습니다.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _buildHelloPage(context),
        );
      },
    );
  }

  Widget _buildHelloPage(BuildContext context) {

    // 선택된 인형 이미지 경로 가져오기
    final selectedDollImagePath =
        Provider.of<DollProvider>(context).selectedDollImagePath ??
            'assets/images/dolls/default.png'; // 선택되지 않았을 경우 기본 이미지

    final selectedDollName =
        Provider.of<DollProvider>(context).selectedDollName ?? "걱정인형"; // 선택되지 않았을 경우 기본 이미지


    return Stack(
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
          top: 100,
          left: 0,
          right: 0, // left와 right를 모두 0으로 두고
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

        // 말풍선 카드(절대 위치, 고정 크기)
        Positioned(
          top: 390,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 305,
              height: 150,
              child: BalloonCard(
                content: '안녕! 나는 너만의 걱정인형 ' + selectedDollName + '이야.\n'
                    '오늘도 행복한 하루 보내~\n'
                    '걱정이 있으면 나한테 털어놔봐!',
              ),
            ),
          ),
        ),

        // BalloonDisplay(
        //   balloonSize: 150, // 풍선 크기 조정
        //   // redBalloonOffset: Offset(50, 100), // 빨간 풍선 위치
        //   // yellowBalloonOffset: Offset(50, 200), // 노란 풍선 위치
        // ),

        // 걱정 털어놓기 버튼(절대 위치, 고정 크기)
        Positioned(
          top: 570,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 305,
              height: 50,
              child: WorryButton(
                text: '걱정 털어놓기',
                onPressed: () {
                  _audioPlayer.stop();
                  // Navigator를 사용해 MyWorryPage로 이동
                  _navigatorKey.currentState!.push(
                    MaterialPageRoute(builder: (context) => MyWorryPage()),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final Map<String, String> MapFirstMessgaes = {
  '토순': 'https://cdn.typecast.ai/data/s/2025/1/22/light-speakcore-worker-7cbf478964-8s5nx/bd467659-bba5-4e5f-9815-f93d8816df32.wav?Expires=1737631292&Signature=BTxR-YnE43qJBcak6v3~unw4IVvkFzdaGSCiAnB4SiFX2FcEdjooCa2AAg~ff~5bJCt-Xj06FQnNgLbmvDhG0LxRHfLkBOO9Xk86yOd~u6sQV2dC4exnFFxbHbCMqsjjBmZQPs78-Ch~Z8aIwpuB2pkd9Fc2r1i1sluAYPGDtITUvjLNRQZxiHdaFzQSyoP-ypmNC7QCn65mU65~mID124UeLgDe6o6OSmzTg9dhwMQy5hSb4NqjthLHur95Hyesj9B0Z33M3XQxEo1M45wWicxzJB3hufqCyaXHyKt1Xcl0zO-ssZsLYGcYzY~t0pu-rU8tXOd6yO6WqABKN1R9FA__&Key-Pair-Id=K11PO7SMLJYOIE',
  '곰돌': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-7f5b66db69-zlsqs/53bdfcce-5f2d-4852-9c61-470f3d76f84c.wav?Expires=1737700820&Signature=e~zHQAkIdz9Ta-ZuWCv5rQJK7aBJlOJr2~WH2oYP2LTj~RiOzT~rh1CAk-jOQPYz606YRZE1oaYuXMd07O5h4FiJ5IroZ8mIk5r5ijBqqtBEw9MpzGgt0HvpGxInANJnNCByK-cL5-~BAb6Jf0IAjIiwwKDiIyr3MciFPrxezebu6j87HMrOhUbqTq7OkOIsO2yh2hDlqjgzzAsGmNymklqOVZX~YWjl2UxgutGCQfHPRoQDbNAAydkAFvlz~pngen6jFOFHOmdSYEK0SnUsZFnsEFapV5BP177AkychktXtCRam2zEt0WynK9DFUV8rIybK-wMhQsjqNTnkACwNNg__&Key-Pair-Id=K11PO7SMLJYOIE',
  '길인': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-7f5b66db69-vsd6n/3d14d8b8-214d-4696-9ce6-1857b74516c1.wav?Expires=1737701160&Signature=XG7ATZSZuOcavNbOB3msRQfHV13Uwg4FshjMUt0cNaWRHFHiLN2yTnHDk5D-YLZBgHBJiCW68qDlj65i-ZsXnfKFs-7nSeB9SLHU-CukIAdL4oTJ7Nebz--QXPTKJCqxg9gaH88MQKQM1ZW1bWTtXOxy7U0~1Ql40oMx2I5AIEJSs1trRzjm3oWbwDNKSozEHQ1l6APr5saqfmAEe58NmpWPDfzoM8DfvEjRvHRXUwvmtViXPkh6d3zuS2orfI7MnmvGLm30j0vkLD1V2pLzPVdVUE6~AyLcHI8tr~Vg19S5oV-R4dY6Z3nLjKq9n8NjLeq1woBBUiNX-lX8PhShog__&Key-Pair-Id=K11PO7SMLJYOIE',
  '어흥': '',
  '개굴': '',
  '늘봉': '',
};

