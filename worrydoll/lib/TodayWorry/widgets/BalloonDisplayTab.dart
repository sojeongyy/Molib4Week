import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/DollProvider.dart';

class BalloonDisplayTab extends StatelessWidget {
  final double balloonSize;
  final Offset redBalloonOffset;
  final Offset yellowBalloonOffset;
  final VoidCallback? onRedBalloonTap;
  final VoidCallback? onYellowBalloonTap;

  const BalloonDisplayTab({
    Key? key,
    required this.balloonSize,
    this.redBalloonOffset = const Offset(55, 150),
    this.yellowBalloonOffset = const Offset(55, 150),
    this.onRedBalloonTap,
    this.onYellowBalloonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DollProvider>(
      builder: (context, dollProvider, child) {
        return Stack(
          children: [
            // 빨간 풍선 (balloonCount > 0일 때만 표시)
            if (dollProvider.balloonCount > 0)
              Positioned(
                top: redBalloonOffset.dy,
                right: redBalloonOffset.dx,
                child: GestureDetector(
                  onTap: onRedBalloonTap,
                  child: Image.asset(
                    'assets/images/balloons/red_balloon.png',
                    height: balloonSize,
                    width: balloonSize,
                  ),
                ),
              ),
            // 노란 풍선 (balloonCount > 1일 때만 표시)
            if (dollProvider.balloonCount > 1)
              Positioned(
                top: yellowBalloonOffset.dy,
                left: yellowBalloonOffset.dx,
                child: GestureDetector(
                  onTap: onYellowBalloonTap,
                  child: Image.asset(
                    'assets/images/balloons/yellow_balloon.png',
                    height: balloonSize,
                    width: balloonSize,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
