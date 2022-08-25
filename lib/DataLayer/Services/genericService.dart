import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:ts_app_development/Generic/APIConstant/apiConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Generic/Functions/functions.dart';
import '../Models/ApiError/apiError.dart';
import '../Models/ApiResponse/ApiResponse.dart';

class GenericService {
  static Future<ApiResponse> getData(
      {required String url,
      required dynamic hashMapBody,
      String request = 'POST', bool addKeyParam=false}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Headers HashMap
      final prefs = await SharedPreferences. getInstance();
      // Try reading data from the counter key. If it doesn't exist, return 0.
      final user = prefs.getString('user') ?? '';
      final appKey = prefs.getString('appKey') ?? '';

      Map<String, dynamic> userMap = jsonDecode(user);
      var hashMapHeader = <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type" : 'application/json'
      };
      if (request == 'POST') {
        Uri dataURL;
        if (hashMapBody.runtimeType.toString() == 'List<Map<String, String>>' || hashMapBody.runtimeType.toString() == 'List<Map<String, dynamic>>') {
          dataURL = Uri.parse(
              '${ApiConstant.clientAPIs[appKey]!['baseURLLocal']}$url');
        } else {
          for (int i = 0; i < hashMapBody.keys.length; i++) {
            if (hashMapBody[hashMapBody.keys.elementAt(i)] == null ||
                hashMapBody[hashMapBody.keys.elementAt(i)] == "null") {
              hashMapBody.remove(hashMapBody.keys.elementAt(i));
            }
          }
          hashMapBody['key'] = appKey;
          dataURL = Uri(
              scheme: 'http',
              host: ApiConstant.clientAPIs[appKey]!['baseHost'],
              port: ApiConstant.clientAPIs[appKey]!['baseHostPort'],
              path: url,
              queryParameters: hashMapBody);
        }
        final response =
            await http.post(dataURL, headers: hashMapHeader, body: jsonEncode(hashMapBody));
        switch (response.statusCode) {
          case 200:
            apiResponse.Data = jsonDecode(response.body);
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
      } else if (request == 'GET') {
        Uri dataURL;
        for (int i = 0; i < hashMapBody.keys.length; i++) {
          if (hashMapBody[hashMapBody.keys.elementAt(i)] == null ||
              hashMapBody[hashMapBody.keys.elementAt(i)] == "null") {
            hashMapBody.remove(hashMapBody.keys.elementAt(i));
          }
        }
        if (addKeyParam) {
          hashMapBody['key'] = appKey;
        }
        dataURL = Uri(
            scheme: ApiConstant.clientAPIs[appKey]!['scheme'],
            host: ApiConstant.clientAPIs[appKey]!['baseHost'],
            port: ApiConstant.clientAPIs[appKey]!['baseHostPort'] != "" ? ApiConstant.clientAPIs[appKey]!['baseHostPort'] : null,
            path: url,
            queryParameters: hashMapBody);
        final response = await http.get(dataURL, headers: hashMapHeader);
        switch (response.statusCode) {
          case 200:
            apiResponse.Data = response.body;
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
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  static createParameters(obj) {
    var obj2 = [];
    obj.forEach((key, value) {
      obj2.add({
        'TypeId': '0',
        'Parameter': key.toString(),
        'SoftwareModuleFormComponentId': '0',
        'DataType': '',
        'Value': '',
        'Value2': value.toString()
      });
    });
    return obj2.toString();
  }
}
