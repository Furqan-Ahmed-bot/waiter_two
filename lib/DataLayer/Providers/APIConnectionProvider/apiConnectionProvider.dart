import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIConnectionProvider with ChangeNotifier{
  String _selectedAppKey = '';

  String get selectedAppKey => _selectedAppKey;

  void setAppKey() async {
    final prefs = await SharedPreferences.getInstance();
    final appKey = prefs.getString('appKey') ?? '';
    _selectedAppKey = appKey;
    notifyListeners();
  }

  void resetAppKey() {
    _selectedAppKey = '';
    notifyListeners();
  }
}