import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  List<dynamic> _rolesData = [];
  List<dynamic> _attendanceStatusData = [];

  List<dynamic> get rolesData => _rolesData;
  List<dynamic> get attendanceStatusData => _attendanceStatusData;


  Future<void> setAttendanceData(attendanceStatusData) async {
    _attendanceStatusData = await attendanceStatusData;
    notifyListeners();
  }

  Future<void> setRolesData(rolesData) async {
    _rolesData = await rolesData;
    notifyListeners();
  }

  clearData() {
    _rolesData = [];
    _attendanceStatusData = [];
    notifyListeners();
  }
}