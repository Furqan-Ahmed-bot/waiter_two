class DealSave {
  int? ItemGroupId;
  String? barcode;
  double? Quantity;

  DealSave({this.ItemGroupId, this.barcode, this.Quantity});

  DealSave.fromJson(Map<String, dynamic> json) {
    ItemGroupId = json['ItemGroupId'];
    barcode = json['Barcode'];
    Quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemGroupId'] = this.ItemGroupId;
    data['Barcode'] = this.barcode;
    data['Quantity'] = this.Quantity;
    return data;
  }
}