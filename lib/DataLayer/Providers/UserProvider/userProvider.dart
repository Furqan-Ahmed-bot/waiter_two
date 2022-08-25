import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Generic/Functions/functions.dart';

class UserSessionProvider with ChangeNotifier {
  Map<String, dynamic> _userData = {};
  List<dynamic> _rolesData = [];


  Map<String, dynamic> get userData => _userData;
  List<dynamic> get rolesData => _rolesData;

  Future<bool> checkUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = prefs.getString('user') ?? 0;
      if (user != 0) {
        final userMap = jsonDecode(user.toString());
        _userData = userMap;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch(err){
      return false;
    }
  }

  setUserRolesData(List<dynamic> roles) {
    _rolesData = roles;
    notifyListeners();
  }
}
