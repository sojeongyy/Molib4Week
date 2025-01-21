import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/DollProvider.dart';

class BalloonDisplay extends StatelessWidget {
  /// 풍선의 크기 (기본값: 170)
  final double balloonSize;

  /// 빨간 풍선의 위치
  final Offset redBalloonOffset;

  /// 노란 풍선의 위치
  final Offset yellowBalloonOffset;

  const BalloonDisplay({
    Key? key,
    this.balloonSize = 170,
    this.redBalloonOffset = const Offset(80, 130),
    this.yellowBalloonOffset = const Offset(80, 130),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 빨간 풍선
        Consumer<DollProvider>(
          builder: (context, dollProvider, child) {
            if (dollProvider.balloonCount > 0) {
              return Positioned(
                top: redBalloonOffset.dy,
                right: redBalloonOffset.dx,
                child: Image.asset(
                  'assets/images/balloons/red_balloon.png',
                  height: balloonSize,
                  fit: BoxFit.contain,
                ),
              );
            }
            return Container(); // 풍선이 없으면 아무것도 렌더링하지 않음
          },
        ),
        // 노란 풍선
        Consumer<DollProvider>(
          builder: (context, dollProvider, child) {
            if (dollProvider.balloonCount > 1) {
              return Positioned(
                top: yellowBalloonOffset.dy,
                left: yellowBalloonOffset.dx,
                child: Image.asset(
                  'assets/images/balloons/yellow_balloon.png',
                  height: balloonSize,
                  fit: BoxFit.contain,
                ),
              );
            }
            return Container(); // 풍선이 없으면 아무것도 렌더링하지 않음
          },
        ),
      ],
    );
  }
}
