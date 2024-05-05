import 'package:flutter/material.dart';

class YearState with ChangeNotifier {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  int get currentYear => _year;

  int get currentMonth => _month;

  setCurrentYear(int year) {
    _year = year;
  }

  setCurrentMonth(int month) {
    _month = month;
  }
}
