class DealModel {
  int? id;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  int? saleTypeId;
  Null? saleType;
  String? dataEntryDate;
  int? productCategoryId;
  String? productCategory;
  int? topLevelProductCategoryId;
  String? topLevelProductCategory;
  int? dealId;
  String? barcode;
  String? deal;
  double? saleRate;
  List<Itemgroups>? itemgroups;
  int counter = 0;

  DealModel(
      {this.id,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.saleTypeId,
        this.saleType,
        this.dataEntryDate,
        this.productCategoryId,
        this.productCategory,
        this.topLevelProductCategoryId,
        this.topLevelProductCategory,
        this.dealId,
        this.barcode,
        this.deal,
        this.saleRate,
        this.itemgroups});

  DealModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    saleTypeId = json['SaleTypeId'];
    saleType = json['SaleType'];
    dataEntryDate = json['DataEntryDate'];
    productCategoryId = json['ProductCategoryId'];
    productCategory = json['ProductCategory'];
    topLevelProductCategoryId = json['TopLevelProductCategoryId'];
    topLevelProductCategory = json['TopLevelProductCategory'];
    dealId = json['DealId'];
    barcode = json['Barcode'];
    deal = json['Deal'];
    saleRate = json['SaleRate'];
    if (json['Itemgroups'] != null) {
      itemgroups = <Itemgroups>[];
      json['Itemgroups'].forEach((v) {
        itemgroups!.add(new Itemgroups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['SaleTypeId'] = this.saleTypeId;
    data['SaleType'] = this.saleType;
    data['DataEntryDate'] = this.dataEntryDate;
    data['ProductCategoryId'] = this.productCategoryId;
    data['ProductCategory'] = this.productCategory;
    data['TopLevelProductCategoryId'] = this.topLevelProductCategoryId;
    data['TopLevelProductCategory'] = this.topLevelProductCategory;
    data['DealId'] = this.dealId;
    data['Barcode'] = this.barcode;
    data['Deal'] = this.deal;
    data['SaleRate'] = this.saleRate;
    if (this.itemgroups != null) {
      data['Itemgroups'] = this.itemgroups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Itemgroups {
  int? itemGroupId;
  double? quantity;
  bool? multiSelection;
  List<Items>? items;
  double counter = 0.0;

  Itemgroups(
      {this.itemGroupId, this.quantity, this.multiSelection, this.items});

  Itemgroups.fromJson(Map<String, dynamic> json) {
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
  double counter = 0.0;

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