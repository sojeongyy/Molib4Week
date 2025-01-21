import 'package:flutter/material.dart';

class DollProvider extends ChangeNotifier {
  String? _selectedDollName;
  String? _selectedDollImagePath;
  int _balloonCount = 0; // 인형이 가진 풍선 개수

  String? get selectedDollName => _selectedDollName;
  String? get selectedDollImagePath => _selectedDollImagePath;
  int get balloonCount => _balloonCount; // 풍선 개수 가져오기

  void selectDoll(String dollName, String imagePath) {
    _selectedDollName = dollName;
    _selectedDollImagePath = imagePath;
    notifyListeners();
  }

  // 풍선 추가
  void addBalloon() {
    _balloonCount++;
    notifyListeners(); // 상태 변경 알림
  }

  // 풍선 감소 (최소값 0)
  void removeBalloon() {
    if (_balloonCount > 0) {
      _balloonCount--;
      notifyListeners(); // 상태 변경 알림
    }
  }

  // 풍선 개수 초기화
  void resetBalloons() {
    _balloonCount = 0;
    notifyListeners(); // 상태 변경 알림
  }
}
