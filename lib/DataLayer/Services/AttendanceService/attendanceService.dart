import 'package:ts_app_development/DataLayer/Services/genericService.dart';
import '../../Models/ApiResponse/ApiResponse.dart';

class AttendanceService {
  static Future<ApiResponse> getAttendanceStatus(
      String employeeInformationId) async {
    final response = await GenericService.getData(
        url: "TSBE/Attendance/GetAttendanceStatus2",
        hashMapBody: {
          "EmployeeInformationId": employeeInformationId,
        },
        request: 'GET');
    return response;
  }

  static Future<ApiResponse> getEmployeeAttendanceHistory(Map<String, String> filterList) async {
    final response = await GenericService.getData(
        url: "TSBE/Attendance/GetEmployeeAttendanceHistory",
        hashMapBody: filterList,
        request: 'GET', addKeyParam: true);
    return response;
  }

  static Future<ApiResponse> getEmployeeAttendanceSummary(Map<String, String> filterList) async {
    final response = await GenericService.getData(
        url: "TSBE/Attendance/GetAttendanceSummary",
        hashMapBody: filterList,
        request: 'GET', addKeyParam: true);
    return response;
  }

  static Future<ApiResponse> saveAttendanceRecord(Map<String, String>  filterList) async {
    final response = await GenericService.getData(
        url: "TSBE/Attendance/SaveAttendanceRecord",
        hashMapBody: filterList,
        request: 'POST', addKeyParam: true);
    return response;
  }
}
