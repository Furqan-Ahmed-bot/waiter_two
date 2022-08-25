import '../../Models/ApiResponse/ApiResponse.dart';
import '../genericService.dart';

class PayrollService {
  static Future<ApiResponse> getEmployeePayroll(List<Map<String, dynamic>> filterList) async {
    final response = await GenericService.getData(
        url: "TSBE/Payroll/EmployeePayroll",
        hashMapBody: filterList ,request: 'POST');
    return response;
  }
}