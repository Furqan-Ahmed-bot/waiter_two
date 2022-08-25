class DealGroupModel {
  int? itemGroupId;
  int? quantity;
  bool? multiSelection;
  List<Items>? items;

  DealGroupModel(
      {this.itemGroupId, this.quantity, this.multiSelection, this.items});

  DealGroupModel.fromJson(Map<String, dynamic> json) {
    itemGroupId = json['ItemGroupId'];
    quantity = json['Quantity'];
    multiSelection = json['MultiSelection'];
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemGroupId'] = this.itemGroupId;
    data['Quantity'] = this.quantity;
    data['MultiSelection'] = this.multiSelection;
    if (this.items != null) {
      data['Items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? productItemId;
  String? barcode;
  String? product;


  Items({this.productItemId, this.barcode, this.product});

  Items.fromJson(Map<String, dynamic> json) {
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