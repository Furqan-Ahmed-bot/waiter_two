import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier {
  Color _selectedPrimaryColor = const Color(0xFFb54f40);

  // Getters
  Color get selectedPrimaryColor => _selectedPrimaryColor;

  // Setting Primary Color
  void setPrimaryColor(int value) {
    _selectedPrimaryColor = Color(value);
    notifyListeners();
  }
}
