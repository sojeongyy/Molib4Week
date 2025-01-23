import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worrydoll/SelectDoll/widgets/confirm_doll_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/DollProvider.dart';
import '../core/colors.dart';

class SelectDollPage extends StatefulWidget {
  @override
  _SelectDollPageState createState() => _SelectDollPageState();
}

class _SelectDollPageState extends State<SelectDollPage> {
  String? _selectedDollName; // 어느 인형이 선택되었는지 저장
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.stop(); // 페이지를 벗어날 때 재생 중지
    _audioPlayer.dispose(); // AudioPlayer 해제
    super.dispose();
  }

  void _playHelloMessage(String dollName) async {
    final url = MapHelloMessgaes[dollName];
    if (url != null && url.isNotEmpty) {
      await _audioPlayer.stop(); // 기존 재생 중지
      await _audioPlayer.play(UrlSource(url)); // 새로운 URL 재생
    }
  }

  void _stopHelloMessage() async {
    await _audioPlayer.stop(); // 재생 중지
  }

  void _onDollSelected(BuildContext context, String dollName, String imagePath) {
    setState(() {
      _selectedDollName = dollName;
    });
    _playHelloMessage(dollName); // 인형 선택 시 오디오 재생
    Provider.of<DollProvider>(context, listen: false).selectDoll(dollName, imagePath);
  }
  void _showConfirmationPopup(BuildContext context) {
    if (_selectedDollName == null) return;

    final dollImagePath = Provider.of<DollProvider>(context, listen: false).selectedDollImagePath;

    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDollDialog(
          dollName: _selectedDollName!,
          dollImagePath: dollImagePath ?? 'assets/images/dolls/default.png',
          onConfirm: () {
            _stopHelloMessage();
            Navigator.of(context).pushReplacementNamed('/home');
          },
        );
      },
    );
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
                          onTap: () => _onDollSelected(context, '곰돌', 'assets/images/dolls/bear.png'),
                          isSelected: _selectedDollName == '곰돌',
                        ),
                        SizedBox(width: 50),
                        DollImage(
                          imagePath: 'assets/images/dolls/frog.png',
                          onTap: () => _onDollSelected(context, '개굴', 'assets/images/dolls/frog.png'),
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
                          onTap: () => _onDollSelected(context, '길인', 'assets/images/dolls/giraffe.png'),
                          isSelected: _selectedDollName == '길인',
                        ),
                        SizedBox(width: 50),
                        DollImage(
                          imagePath: 'assets/images/dolls/rabbit.png',
                          onTap: () => _onDollSelected(context, '토순', 'assets/images/dolls/rabbit.png'),
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
                          onTap: () => _onDollSelected(context, '어흥', 'assets/images/dolls/lion.png'),
                          isSelected: _selectedDollName == '어흥',
                        ),
                        SizedBox(width: 50),
                        DollImage(
                          imagePath: 'assets/images/dolls/slow.png',
                          onTap: () => _onDollSelected(context, '늘봉', 'assets/images/dolls/slow.png'),
                          isSelected: _selectedDollName == '늘봉',
                        ),
                      ],
                    ),
                  ],
                ),

                // 결정 버튼
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectedDollName != null
                      ? () => _showConfirmationPopup(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    '결정',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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

final Map<String, String> MapHelloMessgaes = {
  '토순': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-6c687f585b-xxrg5/a09ec43a-963b-4033-8859-63401c26bf57.wav?Expires=1737710462&Signature=lE6o3jC-3QNgLFOPBjdoCaUNTVcFPRsbx-cjj5-iDaiJ1I2yK6Qbof-hfY5LsRuMS5YWyEJWqav~LCnjYUPnMiMeZe~K8LPb7oZ3lk2Ccc3MfdWIDrveEHJ~Re2zGpVNAtxaIAwftO56PzEnEb79E1nP37ZcfrSshXfb9D3SB~aOlFwfcqTgC6H698Zjp4guNuFTMeW2MB3UVl8njb4Pxweqfr9wJD64Xq0bv8O7nk8t45WJj20kp~-xBrYzzqn39y3AwdtlTSKAhw4kyZpd~B9ROuJGAnO9m~fAv46eN469qYZwHdHFxUjpmOYB-fOh-Rifj5ens3p135o5azGyOw__&Key-Pair-Id=K11PO7SMLJYOIE',
  '곰돌': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-6c687f585b-9sg9s/b50fd143-cc8c-42d0-a0be-e6937934eddc.wav?Expires=1737710539&Signature=nELWvN5zVh7ctzuykoDkChjCDT0gIw7asjZ0ELvpFyg1QP0f36It2tmqfCCcF8J~nKUS7mQnxfk-NML2HTzygXA2Q8nr5xnIWBj1L5Thyj0jnvCTRQkJXXOAcDSNbtbGfV7MdpsWbo7l5mvUbtWrLXbC-keovGop3jtRwez9fQkXbJ1KSHaU-LiF-bX~MXVEWo7XM~rXF7ac~Dvl67-jJhTru-EAP9Fv-YUrTvlBZJyLrUtp61z6CEMJ8oTHXYBosFOOTAsblwqJsuUz~oEa9EgO58M8PkVV4kp-NkuQHx7qe1i6~EWD5xg69LWHFNg00c4aGaiLp1tOcDdunMJIeA__&Key-Pair-Id=K11PO7SMLJYOIE',
  '길인': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-6c687f585b-w5ttc/3d8c1533-ff26-46a7-9a8e-ba65e13ff6ea.wav?Expires=1737710312&Signature=yFd8PFu2gTCmerAT1O~wCwdkCC-WVQnOS9QW~6Oo-jA0IKuDTvfNxp79~2osu4sKwyNw3ssN6QCopPAMDoPJXMj6RvuMPxPl6PuKkd3~XG3jQUJaCCYcIF2xh6tSZleEa3mMQtJSC0GsIs9t0QengeUdIbTIcWAAosHSRD4OrQx5Q3KOjeLhzWxtQp7vp3CyKAfLvsz0T2SGnteP8cjk1PIZBrosf0iBDL4kKrGOkyOE~DWi5Hk6IUavwJbPZjkEU59s2LUB1iGsU7CEqnIP5SYrupZwiaS-0tSh17TXjaMp2~vOuE9PZJdvqs946Bd87ZZSvqlyl2egjdxmLl3VbA__&Key-Pair-Id=K11PO7SMLJYOIE',
  '어흥': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-6c687f585b-2tj8b/815b0d87-4bba-4959-90bc-5da5769d7e6a.wav?Expires=1737711040&Signature=Fucs3vF01S86FjzS2U1mFeas5nIo3cTtMYNYnVc6Szf9m3uObRir3ZJvL~eqnVLHy3Fon8BJ2pkF9BZeWaJp2vdmi4bhpFlN1-dv-YcYTeHtV-AlNllb5ELHaoyY0HJKCd7P3ZfXMl8fTGSXdLoWub2n9s0fm43595uAZ5ahq23mCusgZgMYYdf1FUvOVNynDuTlgWScmD5ltXth1j73yGsennXx14kpyhI3cdBfdm3f3U3BJX74sTvcbHW9cUvJtH8lmUWZ-SCuaToJCDRn5E4eFqU1yHSkYB1STLAeaXq4gMqYX5QV6sWnQ8m51pCQWMsVug36cnxgaUTkpb0Jgw__&Key-Pair-Id=K11PO7SMLJYOIE',
  '개굴': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-6c687f585b-2tj8b/99f2351b-456a-4e18-a13b-7e586d31e423.wav?Expires=1737711096&Signature=qZGLlB7XytwMP9JZZ6ytP9CBO5J94OhEqAZ-3mFDAgZ8KcNHX5IhhOYraR~cMIlJWVfLgcsyhGNBnvuy4mcdG6Ha7lBPtxnoC0wsdVBGbmnftOSO~MWeT2Vt7wa0F30X2PzkBakTolIlwFFTpEzCFAn0lk5sDxKxyOjCJiVpuxu~cwAUei79fmHZXBMYB8ypGBD3Mk5k1k6S3sizQdXf3RKAhTbzW6MZR5BMwxuDe~AB53-TQufKsLtHD5N5wh42N1YDnUPc85BWBIBh-jhpDEnrqn0jdDdX8OLXE7S3vKYFfKN1MHDdhGe3-L93ZArpK~9u90NyqHHwmK~QKbhnXQ__&Key-Pair-Id=K11PO7SMLJYOIE',
  '늘봉': 'https://cdn.typecast.ai/data/s/2025/1/23/light-speakcore-worker-6c687f585b-hst9k/381d868f-7893-4f38-9a9d-afcc83662694.wav?Expires=1737711166&Signature=X~tVtNw~tGUHiLE-ngxQE2gJFfLGQM~aqqvmvqVoYJtL-7kJu2Xqn6AXGFxa4Qpy20iSQB~-Agk4fngYpQo6YqDG6WJZJeeckWG0U2uCsZQtVA3unzSVMlmxpCsJpr~-DEURignOIPcWzffimf6otGqQwgKzF-F6Psc9yGWnPwhLlaTxZC-OSHsvOHCW90j3oILXYwMQjLD-lL9t9S5thCKMWHM946w0b~KZ4A8JlfcpxjFcRGZnqisywdmiSNtRH~sv75o0j4uo89UqVOQ0MOVmRFAHcjqwEEgc4AkntUfoh-jsrZWgXKhiTw79Wn8l2czwXCsQzemoKQRASTT0Xw__&Key-Pair-Id=K11PO7SMLJYOIE',
};
