import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/Generic/AppScreens/appScreens.dart';
import 'package:ts_app_development/UserControls/PopUpDialog/popupDialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../appConst.dart';

class Functions {
  // Open Map Function
  static Future<void> openGoogleMap(BuildContext context, String url) async {
    String googleUrl = url;
    if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(googleUrl);
    }
    else {
      // throw 'Could not open the map.';
      Functions.ShowPopUpDialog(
        context,
        'Error In Location',
        Icon(
          Icons.error_outline_sharp,
          color: context.read<ThemeProvider>().selectedPrimaryColor,
          size: 80,
        ),
            () => {},
        false,
        isHeader: true,
        isCloseBtn: true,
      );
    }
  }

  // Parse DateString
  static String parseDateString(String dateText) {
    try {
      return '${Functions.getDayNumber(DateTime.parse(dateText).day)}.${AppConst.months[DateTime.parse(dateText).month - 1]}.${DateTime.parse(dateText).year} ${Functions.formatTimeOfDay(dateText)}';
    } catch (e) {
      return dateText;
    }
  }


  // Scale Factor Calculator
  static double getScaleFactor(Size size) {
    if (size.width > 400 && size.width <= 450) {
      return 1.0;
    } else if (size.width > 350 && size.width <= 400) {
      return 0.90;
    } else if (size.width > 300 && size.width <= 350) {
      return 0.80;
    } else if (size.width > 250 && size.width <= 300) {
      return 0.70;
    } else if (size.width > 200 && size.width <= 250) {
      return 0.60;
    } else {
      return 0.50;
    }
  }

  // Phone Dialer
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  // Scrolling to a Expansion Key Tile
  static void scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  // Get Keys Present in a Map in List
  static List<dynamic> getKeysInList(data) {
    var keysPresent = [];
    for (int i = 0; i < data.length; i++) {
      data[i].keys.forEach((key) {
        keysPresent.add(key);
      });
    }
    return keysPresent;
  }

  // Get Grouped By Map
  static dynamic getGroupedByMap(data, String keyToGroup) {
    List result = data
        .fold({}, (previousValue, element) {
          Map val = previousValue as Map;
          String date = element[keyToGroup];
          if (!val.containsKey(date)) {
            val[date] = [];
          }
          // element.remove('release_date');
          val[date]?.add(element);
          return val;
        })
        .entries
        .map((e) => {e.key: e.value})
        .toList();

    return result;
  }

  // Get App title
  static String getAppTitle(String route) {
    // if (route == '/Dashboard') {
    //   return 'Dashboard';
    // } else if (route == '/settings') {
    //   return 'Settings';
    // } else {
    //   return route.split('/')[1];
    // }
    bool titleSet = false;
    for (int i = 0; i < AppScreens.screens.length; i++) {
      if (route == AppScreens.screens[i]['Route']) {
        titleSet = true;
        return AppScreens.screens[i]['Title'];
      }
    }
    if (!titleSet) {
      if (route == '/Dashboard') {
        titleSet = true;
        return 'Dashboard';
      } else if (route == '/settings') {
        titleSet = true;
        return 'Settings';
      } else if (route == '/updatePassword') {
        titleSet = true;
        return 'Update Password';
      } else if (route == '/about') {
        titleSet = true;
        return 'About';
      } else if (route == '/faq') {
        titleSet = true;
        return 'FAQs';
      } else {
        titleSet = true;
        return 'Dashboard';
      }
    } else {
      return 'Dashboard';
    }
  }

  // Get Twelve Months Before Date
  static DateTime getTwelveMonthsDateTime(DateTime date) {
    var month = date.month;
    var year = date.year;
    var loopCount = 1;
    var countThisYear = 0;
    var countPreviousYear = 0;
    while (loopCount <= 12) {
      if (month > 0) {
        countThisYear += 1;
        month -= 1;
        loopCount += 1;
      } else {
        countPreviousYear += 1;
        month -= 1;
        loopCount += 1;
      }
    }
    if (countPreviousYear != 0) {
      return DateTime.parse(
          '${date.year - 1}-${Functions.getMonthNumber(12 - countPreviousYear)}-01T00:00:00');
    } else {
      return DateTime.parse(
          '${date.year}-${Functions.getMonthNumber(12 - countThisYear)}-T00:00:00');
    }
  }

  // BAse64 to Image
  static dynamic imageFromBase64String(String base64String) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(200.0),
      child: Image.memory(
        base64Decode(base64String),
        fit: BoxFit.cover,
      ),
    );
  }

  // Get No Of Months
  static int getDaysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  // Get Month Number
  static String getDayNumber(int day) {
    if (day < 10) {
      return '0$day';
    } else {
      return '$day';
    }
  }

  // Get Month Number
  static String getMonthNumber(int month) {
    if (month < 10) {
      return '0$month';
    } else {
      return '$month';
    }
  }

  // Get Month Number
  static String getThreeEndMonth(int month) {
    if (month == 2) {
      return '12';
    } else if (month == 1) {
      return '11';
    } else {
      if (month < 10) {
        return '0${month - 2}';
      } else {
        return '$month';
      }
    }
  }

  static String formatTimeOfDay(String date) {
    final now = DateTime.parse(date);
    final dt = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final format = DateFormat.jms(); //"6:00 AM"
    return format.format(dt);
  }

  // Converting into List
  static List convertToListOfObjects(String input) {
    List output;
    try {
      output = json.decode(input);
      return output;
    } catch (err) {
      print('The input is not a string representation of a list');
      return [];
    }
  }

  // JSON TO MAP
  static jsonStringToMap(String data) {
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  }

  // Show SnackBar
  static ShowSnackBar(BuildContext context, String content) {
    final snackBar = SnackBar(
      backgroundColor: context.read<ThemeProvider>().selectedPrimaryColor,
      elevation: 20.0,
      padding: const EdgeInsets.all(10.0),
      duration: const Duration(milliseconds: 5000),
      content: Text(
        content,
        style: const TextStyle(
          color: AppConst.appColorWhite,
          fontSize: AppConst.appFontSizeh10,
          fontWeight: AppConst.appTextFontWeightMedium,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static ShowPopUpDialog(BuildContext context, String title, Widget content,
      VoidCallback onPressYes, bool isAction,
      {required bool isCloseBtn, required bool isHeader}) {
    showDialog(
        context: context,
        builder: (_) => PopUpDialog(
              title: title,
              content: content,
              onPressYes: onPressYes,
              isAction: isAction,
              isCloseBtn: isCloseBtn,
              isHeader: isHeader,
            ),
        barrierDismissible: true);
  }
}
