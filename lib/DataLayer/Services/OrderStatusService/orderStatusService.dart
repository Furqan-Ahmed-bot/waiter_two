import '../../Models/ApiResponse/ApiResponse.dart';
import '../genericService.dart';

class OrderStatusService {
  static Future<ApiResponse> getRestaurantOrderStatus(List<Map<String, String>> filterList) async {
    final response = await GenericService.getData(
        url: "TSBE/PointOfSale/GetRestaurantOrderStatus",
        hashMapBody: filterList ,request: 'POST');
    return response;
  }

  static Future<ApiResponse> postRestaurantOrderStatus(List<Map<String, String>> filterList) async {
    final response = await GenericService.getData(
        url: "TSBE/PointOfSale/DeliverOrder",
        hashMapBody: filterList ,request: 'POST');
    return response;
  }

  static Future<ApiResponse> getOrderDetails(Map<String, dynamic> filterList) async {
    final response = await GenericService.getData(
        url: "TSBE/Sales/OrderHistory",
        hashMapBody: filterList ,request: 'GET');
    return response;
  }
}