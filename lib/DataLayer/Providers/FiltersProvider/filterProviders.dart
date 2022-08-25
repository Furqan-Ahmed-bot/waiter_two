import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  void setFilter(filterValue) {
    _selectedFilter = filterValue;
    notifyListeners();
  }
}