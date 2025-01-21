import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/WorryDoll/widgets/balloon_card.dart';
import 'package:worrydoll/WorryDoll/widgets/worry_button.dart';

import '../core/DollProvider.dart';
import '../core/colors.dart';
import 'DragBalloonPage.dart';


class WorryingPage extends StatefulWidget {
  // Navigator 키 추가

  //const MyWorryPage({Key? key}) : super(key: key);

  @override
  _WorryingPageState createState() => _WorryingPageState();
}

class _WorryingPageState extends State<WorryingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

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
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _buildBalloonPage(context),
        );
      },
    );
  }

  Widget _buildBalloonPage(BuildContext context) {

    final selectedDollImagePath =
        Provider.of<DollProvider>(context).selectedDollImagePath ??
            'assets/images/dolls/default.png'; // 선택되지 않았을 경우 기본 이미지

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
            top: 100,
            left: 0,
            right: 0,   // left와 right를 모두 0으로 두고
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
                    content: '사실 요즘 일이 잘 안 풀리는 것 같아서 좀 답답해. \n'
                        '어떻게 해야 할지 모르겠어.'
                ),
              ),
            ),
          ),


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
                  text: '걱정 전달하기',
                  onPressed: () {
                    // Navigator를 사용해 MyWorryPage로 이동
                    _navigatorKey.currentState!.push(
                      MaterialPageRoute(builder: (context) => DragBalloonPage()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
