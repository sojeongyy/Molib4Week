import 'package:flutter/material.dart';

import '../DiaryCalendar/DiaryCalendarPage.dart';
import 'DiaryCoverPage.dart';

class DiaryPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          DiaryCoverPage(),
          DiaryCalendarPage(),
        ],
      ),
    );
  }
}