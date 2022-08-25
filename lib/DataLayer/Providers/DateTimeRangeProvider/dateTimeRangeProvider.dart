import 'package:flutter/material.dart';

import '../../../Generic/Functions/functions.dart';

class CustomDateTime {
  final DateTime? start;
  final DateTime? end;
  CustomDateTime({required this.start, required this.end}) {}
}

class DateTimeRangeProvider with ChangeNotifier {
  CustomDateTime _selectedDateTimeRange = CustomDateTime(
    start: DateTime.parse(
        '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}-01T00:00:00'),
    end: DateTime.parse(
        '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}-${Functions.getDaysInMonth(DateTime.now())}T23:59:59'),
  );

  CustomDateTime _customDateRange = CustomDateTime(
    start: DateTime.parse(
        '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}-01T00:00:00'),
    end: DateTime.parse(
        '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}-${Functions.getDaysInMonth(DateTime.now())}T23:59:59'),
  );

  CustomDateTime _selectedThreeMonthsDateTime = CustomDateTime(
    start: DateTime.parse(
        '${DateTime.now().year}-${Functions.getThreeEndMonth(DateTime.now().month)}-01T00:00:00'),
    end: DateTime.parse(
        '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}-${Functions.getDaysInMonth(DateTime.now())}T23:59:59'),
  );

  CustomDateTime _selectedTwelveMonthsDateTime = CustomDateTime(
    start: Functions.getTwelveMonthsDateTime(DateTime.now()),
    end: DateTime.parse(
        '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}-${Functions.getDaysInMonth(DateTime.now())}T23:59:59'),
  );

  CustomDateTime get dateTime => _selectedDateTimeRange;
  CustomDateTime get customDateRange => _customDateRange;
  CustomDateTime get threeMonthsDateTime => _selectedThreeMonthsDateTime;
  CustomDateTime get twelveMonthsDateTime => _selectedTwelveMonthsDateTime;

  Future<bool> setDefaultDateTime(dateTime) async {
    // Current Month All Days To Current Date
    _selectedDateTimeRange = await CustomDateTime(
      start: DateTime.parse(
          '${dateTime.year}-${Functions.getMonthNumber(dateTime.month)}-01T00:00:00'),
      end: DateTime.parse(
          '${dateTime.year}-${Functions.getMonthNumber(dateTime.month)}-${Functions.getDayNumber(dateTime.day)}T23:59:59'),
    );
    notifyListeners();
    return true;
  }

  Future<bool> setCustomDate(dateTimeStart, dateTimeEnd) async {
    // Selected Date Range
    _customDateRange = await CustomDateTime(
      start: DateTime.parse(
          '${dateTimeStart.year}-${Functions.getMonthNumber(dateTimeStart.month)}-${Functions.getDayNumber(dateTimeStart.day)}T00:00:00'),
      end: DateTime.parse(
          '${dateTimeEnd.year}-${Functions.getMonthNumber(dateTimeEnd.month)}-${Functions.getDayNumber(dateTimeEnd.day)}T23:59:59'),
    );
    notifyListeners();
    return true;
  }

  Future<bool> setDateTime(dateTime) async {
    // current Whole Month
    _selectedDateTimeRange = await CustomDateTime(
      start: DateTime.parse(
          '${dateTime.year}-${Functions.getMonthNumber(dateTime.month)}-01T00:00:00'),
      end: DateTime.parse(
          '${dateTime.year}-${Functions.getMonthNumber(dateTime.month)}-${Functions.getDaysInMonth(dateTime)}T23:59:59'),
    );
    notifyListeners();
    return true;
  }

  Future<bool> setThreeMonthsDate(DateTime dateTime) async {
    _selectedThreeMonthsDateTime = await CustomDateTime(
      start: DateTime.parse(
          '${dateTime.year}-${Functions.getThreeEndMonth(dateTime.month)}-01T00:00:00'),
      end: DateTime.parse(
          '${dateTime.year}-${Functions.getMonthNumber(dateTime.month)}-${Functions.getDaysInMonth(dateTime)}T23:59:59'),
    );
    notifyListeners();
    return true;
  }

  Future<bool> setTwelveMonthsDate(DateTime dateTime) async {
    _selectedTwelveMonthsDateTime = await CustomDateTime(
      start: Functions.getTwelveMonthsDateTime(dateTime),
      end: DateTime.parse(
          '${dateTime.year}-${Functions.getMonthNumber(dateTime.month)}-${Functions.getDaysInMonth(dateTime)}T23:59:59'),
    );
    notifyListeners();
    return true;
  }
}
