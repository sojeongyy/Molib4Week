import 'package:flutter/material.dart';

import '../core/colors.dart';

class SelectDollPage extends StatefulWidget {
  @override
  _SelectDollPageState createState() => _SelectDollPageState();
}

class _SelectDollPageState extends State<SelectDollPage> {
  String? _selectedDollName; // 어느 인형이 선택되었는지 저장

  void _onDollSelected(BuildContext context, String dollName) {
    setState(() {
      _selectedDollName = dollName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wood_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // 제목
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: 'ongle',
                      fontSize: 30,
                      color: Colors.black,
                    ),
                    child: Text('나만의 걱정인형을 선택하세요!'),
                    textAlign: TextAlign.center,
                  ),
                ),

                // 첫 번째 줄
                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 5,
                      child: Image.asset(
                        'assets/images/wood_floor.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DollImage(
                          imagePath: 'assets/images/dolls/bear.png',
                          onTap: () => _onDollSelected(context, '곰돌'),
                          isSelected: _selectedDollName == '곰돌',
                        ),
                        SizedBox(width: 50),
                        DollImage(
                          imagePath: 'assets/images/dolls/frog.png',
                          onTap: () => _onDollSelected(context, '개굴'),
                          isSelected: _selectedDollName == '개굴',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // 두 번째 줄
                Stack(
                  children: [
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/wood_floor.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DollImage(
                          imagePath: 'assets/images/dolls/giraffe.png',
                          onTap: () => _onDollSelected(context, '기리니'),
                          isSelected: _selectedDollName == '기리니',
                        ),
                        SizedBox(width: 50),
                        DollImage(
                          imagePath: 'assets/images/dolls/rabbit.png',
                          onTap: () => _onDollSelected(context, '토순'),
                          isSelected: _selectedDollName == '토순',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // 세 번째 줄
                Stack(
                  children: [
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/wood_floor.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DollImage(
                          imagePath: 'assets/images/dolls/lion.png',
                          onTap: () => _onDollSelected(context, '어흥'),
                          isSelected: _selectedDollName == '어흥',
                        ),
                        SizedBox(width: 50),
                        DollImage(
                          imagePath: 'assets/images/dolls/slow.png',
                          onTap: () => _onDollSelected(context, '림보'),
                          isSelected: _selectedDollName == '림보',
                        ),
                      ],
                    ),
                  ],
                ),

                // 결정 버튼
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectedDollName != null
                      ? () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('결정'),
                        content:
                        Text('${_selectedDollName} 인형을 선택했습니다!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            },
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    '결정',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}

// -----------------------------------------------------------------
// DollImage: 흔들림 애니메이션 + 선택 시 크기 증가 추가 (기존 그대로)
// -----------------------------------------------------------------
class DollImage extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final bool isSelected;

  const DollImage({
    required this.imagePath,
    required this.onTap,
    required this.isSelected,
  });

  @override
  _DollImageState createState() => _DollImageState();
}

class _DollImageState extends State<DollImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // (기존 코드) AnimationController 초기화
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // (기존 코드) 좌우 흔들림
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 새로 추가: isSelected일 때 크기 1.2배
    final double scale = widget.isSelected ? 1.2 : 1.0;

    // (기존) 흔들림 + 엉덩이 고정
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.bottomCenter,
            // (기존) rotateZ(_animation.value)
            // (추가) scale(scale)
            transform: Matrix4.identity()
              ..rotateZ(_animation.value)
              ..scale(scale),
            child: child,
          );
        },
        child: Image.asset(
          widget.imagePath,
          height: 148,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
