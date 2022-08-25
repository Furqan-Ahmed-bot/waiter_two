import 'package:flutter/material.dart';

class ProductItems{

  final String itemName;
  final String itemPrice;
  final String image;
  int counter = 0;
  bool isAdded = false;
  ProductItems({required this.itemName, required this.itemPrice,required this.image});

}