import 'package:flutter/material.dart';

class DollProvider extends ChangeNotifier {
  String? _selectedDollName;
  String? _selectedDollImagePath;

  String? get selectedDollName => _selectedDollName;
  String? get selectedDollImagePath => _selectedDollImagePath;

  void selectDoll(String dollName, String imagePath) {
    _selectedDollName = dollName;
    _selectedDollImagePath = imagePath;
    notifyListeners();
  }
}
