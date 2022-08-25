import 'package:ts_app_development/DataLayer/Models/Orders/DealSave.dart';

class OrderModel {
  String? barcode;
  int? quantity;
  int? price;
  String? itemComment;
  List<DealSave>? dealItems;

  OrderModel({this.barcode, this.quantity, this.price, this.itemComment, this.dealItems});

  OrderModel.fromJson(Map<String, dynamic> json) {
    barcode = json['Barcode'];
    quantity = json['Quantity'];
    price = json['Price'];
    itemComment = json['ItemComment'];
    dealItems = json['DealItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Barcode'] = this.barcode;
    data['Quantity'] = this.quantity;
    data['Price'] = this.price;
    data['ItemComment'] = this.itemComment;
    data['DealItems'] = this.dealItems;
    return data;
  }
}