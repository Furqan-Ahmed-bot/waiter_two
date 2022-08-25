class DealItemModel {
  int? productItemId;
  String? barcode;
  String? product;

  DealItemModel({this.productItemId, this.barcode, this.product});

  DealItemModel.fromJson(Map<String, dynamic> json) {
    productItemId = json['ProductItemId'];
    barcode = json['Barcode'];
    product = json['Product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductItemId'] = this.productItemId;
    data['Barcode'] = this.barcode;
    data['Product'] = this.product;
    return data;
  }
}