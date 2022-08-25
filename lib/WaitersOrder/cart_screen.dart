import 'package:flutter/material.dart';
import 'package:ts_app_development/WaitersOrder/orderscart.dart';
class Cart extends StatefulWidget {
  const Cart({ Key? key }) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart Screen',style: TextStyle(color: Colors.white),),),
      body: CartProducts(),
    );
  }
}