import 'package:flutter/material.dart';

class AppConst {
  static const appTitle = "Attendance";
  static const nullString = '--';
  // APP font Sizes
  static const appFontSizeh1 = 100.0;
  static const appFontSizeh2 = 90.0;
  static const appFontSizeh3 = 80.0;
  static const appFontSizeh4 = 70.0;
  static const appFontSizeh5 = 60.0;
  static const appFontSizeh6 = 50.0;
  static const appFontSizeh7 = 40.0;
  static const appFontSizeh8 = 30.0;
  static const appFontSizeh9 = 20.0;
  static const appFontSizeh10 = 18.0;
  static const appFontSizeh11 = 15.0;
  static const appFontSizeh12 = 12.0;
  static const appFontSizeh13 = 20.0;

  // APP Font Weights
  static const FontWeight appTextHintFontWeight = FontWeight.w400;
  static const FontWeight appTextFontWeightBold = FontWeight.w800;
  static const FontWeight appTextFontWeightMedium = FontWeight.w600;
  static const FontWeight appTextFontWeightLight = FontWeight.w500;
  static const FontWeight appTextFontWeightExtraLight = FontWeight.w300;

  // APP Paddings
  static const appMainPaddingLarge = 20.0;
  static const appMainPaddingMedium = 15.0;
  static const appMainPaddingSmall = 10.0;
  static const appMainPaddingExtraSmall = 5.0;
  static const appMainBodyVerticalPadding = 15.0;
  static const appMainBodyHorizontalPadding = 20.0;

  // APP Border Radius
  static const double appButtonsBorderRadiusMax = 5.0;
  static const double appButtonsBorderRadiusMed = 10.0;
  static const double appButtonsBorderRadiusSam = 5.0;
  static const double appInfoContainersBorderRadius = 5.0;
  static const double appOrderStatusContainersBorderRadius = 20.0;

  //APP Colors
  static const Color appColorPrimary = Color(0xFFb54f40);
  static const Color appColorTechnoSysDark = Color(0xFF00202f);
  static const Color appColorTechnoSysBlueLight = Color(0xFF00aeef);
  static const Color appColorSecondary = Color(0xFFFFCC00);
  static const Color appColorPrimaryDark = Color(0xFF00351C);
  static const Color appColorAccent = Color(0xFFFBFBFB);
  static const Color appColorBlack = Color(0xFF000000);
  static const Color appColorGrey = Color(0xFF9C9999);
  static const Color appColorText = Color(0xFF000000);
  static const Color appColorTextRed = Color(0xFFBA0C2F);
  static const Color appColorDarkRed = Color(0xFFFF1746);
  static const Color appColorHint = Color(0xFFC6C6C6);
  static const Color appColorLightTextColor = Color(0xFFEDC2CB);
  static const Color appColorTransparent = Color(0xFF0FFFFF);
  static const Color appColorBlue = Color(0xFF0A80FE);
  static const Color appColorLightBlue = Color(0xDA086ACF);
  static const Color appColorPresent = Color(0xFF00BFA5);
  static const Color appColorTextDarkGray = Color(0xFF484848);
  static const Color appColorTextLightGray = Color(0xFFAAAAAA);
  static const Color appColorSperator = Color(0xFFE3E3E3);
  static const Color appColorIcon = Color(0xFF89C2FE);
  static const Color appColorWhite = Color(0xFFFFFFFF);
  static const Color appColorTextBlack = Color(0xFF111111);
  static const Color appColorSeparator = Color(0xFFd1d1d1);
  static const Color appColorRestDay = Color(0xFFAABCD4);
  static const Color appColorAbsent = Color(0xFFE47F7F);
  static const Color appColorCasualLeave = Color(0xFF89E287);
  static const Color appColorShortLeave = Color(0xFF86C584);
  static const Color appColorHoliday = Color(0xFFEAA254);
  static const Color appColorEarlyOut = Color(0xFFF4B309);
  static const Color appColorAbsent2 = Color(0xFFFD0000);

  static const Map<String, Color> statusColors = {
    'All' : Color(0xFFEDC2CB),
    'Total': Color(0xA30A80FE),
    'Present': Color(0xFF1ABCA6),
    'Rest Day': Color(0xFFAABCD4),
    'Absent': Color(0xFFE47F7F),
    'Leave': Color(0xFF7BB464),
    'Short Leave': Color(0xFF86C584),
    'Holiday': Color(0xFFEAA254),
    'Absent2': Color(0xFFFD0000),
    'On Time': Color(0xFFEAA254),
    'Late In': Color(0xFFF1C40F),
    'Half Day': Color(0xFF1ABCA6),
    'Early Out': Color(0xFF2471A3),
    'Over Time': Color(0xFF373B7B),
  };

  static const List<String> attendanceStatus = [
    'All',
    'Present',
    'Rest Day',
    'Absent',
    'Leave',
    'Short Leave',
    'Holiday',
  ];

  static const Map<String, dynamic> markAttendanceStatusIcons = {
    'Time Out' : Icons.alarm_outlined,
    'Time In' : Icons.timer,
    'Break Out' : Icons.free_breakfast_outlined,
    'Break In' : Icons.free_breakfast_outlined,
    'Lunch Out' : Icons.free_breakfast_outlined,
    'Lunch In' : Icons.free_breakfast_outlined,
    'Pray Out' : Icons.access_time_rounded,
    'Pray In' : Icons.access_time_rounded,
    'Leave Out' : Icons.time_to_leave_outlined,
    'Leave In' : Icons.time_to_leave_outlined,
  };

  static List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}
