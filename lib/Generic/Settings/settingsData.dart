import 'package:flutter/material.dart';

class SettingsData {
  static Map<String, dynamic> settings = {
    // 'Account Preferences': [
    //   {'Icon': Icons.dashboard, 'Name': 'Update Password', 'Route': '/updatePassword'}
    // ],
    'Application Settings': [
      {'Icon': Icons.dashboard, 'Name': 'About', 'Route': '/about'},
      {'Icon': Icons.dashboard, 'Name': 'Help/FAQ', 'Route': '/faq'}
    ],
  };

  static List<List<String>> updatePasswordFaqs = [['How can I change my password?', 'You can change your password using Business Expert Desktop.']];
}
