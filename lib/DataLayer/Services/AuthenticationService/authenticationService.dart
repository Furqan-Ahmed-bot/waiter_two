import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/Generic/APIConstant/apiConstant.dart';
import '../../../Generic/Functions/functions.dart';
import '../../Models/ApiError/apiError.dart';
import '../../Models/ApiResponse/ApiResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../genericService.dart';

class AuthenticationService {
  Future<ApiResponse> authenticateUser(BuildContext context, String username,
      String password, String appKey) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Encrypting
      String basicAuth = encryptBase64Credentials(username, password);
      // Headers HashMap
      Map<String, String> hashMapHeader = setHeaderData(basicAuth, appKey);
      // body HashMap
      Map<String, String> hashMapBody = setBodyData();
      var dataURL = Uri.parse(
          '${ApiConstant.clientAPIs[appKey]!['baseURLLocal']}TSBE/User/FSigninMobileApp');
      final response =
          await http.post(dataURL, headers: hashMapHeader, body: hashMapBody);

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = response.body;
          // obtain shared preferences
          final prefs = await SharedPreferences.getInstance();
          // set value
          await prefs.setString('user', apiResponse.Data.toString());
          await prefs.setString('appKey', appKey);
          break;
        case 401:
          apiResponse.ApiError = {
            'StatusCode' : response.statusCode,
          };
          break;
        default:
          apiResponse.ApiError = {
            'StatusCode' : response.statusCode,
          };
          break;
      }
    } catch (e) {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> logoutUser(
      String userId, String token, String appKey) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Headers HashMap
      var hashMapHeader = <String, String>{"UserId": userId, "token": token};
      var dataURL = Uri.parse(
          '${ApiConstant.clientAPIs[appKey]!['baseURLLocal']}TSBE/User/UserLogOut');
      final response = await http.post(dataURL, headers: hashMapHeader);

      switch (response.statusCode) {
        case 200:
        // obtain shared preferences
          final prefs = await SharedPreferences.getInstance();
          // set value
          await prefs.remove('user');
          await prefs.remove('appKey');
          apiResponse.Data = json.decode(response.body);
          break;
        case 401:
          apiResponse.ApiError = {
            'StatusCode' : response.statusCode,
          };
          break;
        default:
          apiResponse.ApiError = {
            'StatusCode' : response.statusCode,
          };
          break;
      }
    } catch (e) {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  // Password Change
  Future<ApiResponse> changePassword(Map<String, String> hashMapBody) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Headers HashMap
      final prefs = await SharedPreferences.getInstance();
      // Try reading data from the counter key. If it doesn't exist, return 0.
      final user = prefs.getString('user') ?? '';
      final appKey = prefs.getString('appKey') ?? '';
      var userMap = Functions.jsonStringToMap(user);
      var hashMapHeader = <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
      };

      hashMapBody['ContactNumber'] = userMap['LoginId'].toString();
      hashMapBody['tc'] = appKey;
      var dataURL = Uri(
          scheme: 'http',
          host: ApiConstant.baseHost,
          port: ApiConstant.baseHostPort,
          path: 'TSBE/User/UpdatePassword',
          queryParameters: hashMapBody);
      final response =
          await http.post(dataURL, headers: hashMapHeader, body: hashMapBody);

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = json.decode(response.body);
          break;
        case 401:
          apiResponse.ApiError = {
            'StatusCode' : response.statusCode,
          };
          break;
        default:
          apiResponse.ApiError = {
            'StatusCode' : response.statusCode,
          };
          break;
      }
    } catch (e) {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  // Get Roles Details
  static Future<ApiResponse> getRolesDetails(
      Map<String, dynamic> filtersList) async {
    final response = await GenericService.getData(
        url: "TSBE/User/getUserMenuForMobile",
        hashMapBody: filtersList,
        request: 'GET');
    return response;
  }

  // Header Maker
  Map<String, String> setHeaderData(String auth, String appKey) {
    var hashMapHeader = <String, String>{
      "ts": appKey,
      "app": "6289",
      "Authorization": "Basic $auth"
    };
    return hashMapHeader;
  }

  // Encoder
  String encryptBase64Credentials(String username, String password) {
    String credentials = '$username:$password';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    return encoded;
  }

  Map<String, String> setBodyData() {
    var bodyHashMap = <String, String>{
      "WebUserLogId": "asdas",
      "IPAddress": "asdas",
      "IsMobile": "asdas",
      "IsMobile": "asdas",
      "IsMobile": "asdas",
      "SessionId": "asdas"
    };
    return bodyHashMap;
  }
}
