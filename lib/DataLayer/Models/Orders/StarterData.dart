import 'package:flutter/material.dart';

class StarterData{
  final String itemName;
  final String itemPrice;
  final String image;
  int counter = 0;
  bool isAdded = false;
  StarterData({required this.itemName, required this.itemPrice,required this.image});
}