import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/Products.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/StarterData.dart';
import 'package:ts_app_development/UserControls/MasterWidget/EditorWidget.dart';
import 'package:ts_app_development/WaitersOrder/OrdersListScreen.dart';
import 'package:http/http.dart'as http;

class CartProducts extends StatefulWidget {

  CartProducts({ Key? key }) : super(key: key);

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {

  List<OrderModel> ordersList = [];

  final CartController controller = Get.find();

  bool _isLoading = false;

  orderData(order) async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'OrderLines': order,
    };
    try {
      final response = await http.post(
          Uri.parse(
            'http://10.1.1.13:8081/TSBE/EStore/Order',
          ),
          headers: <String, String>{
            'Authorization': 'Basic dGVjaG5vc3lzOlRlY2g3MTA=',
            'TS-AppKey':'foodsinn'
          },
          body: data
      );
      // var datas = (jsonDecode(response.body));
      // print(datas);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        // var res = response.body;
        // var jsonResponse = json.decode(res);
        // int code = jsonResponse['code'];
        // String message = jsonResponse['message'];
        // print(code);
        // print(message);

        Fluttertoast.showToast(
            msg: 'Order Created!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black);

        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));

        //  Navigator.push(context, MaterialPageRoute(
        //      builder: (context) => PreScreenTwo()
        // ));
      } else {
        print('Response Code: ${response.statusCode}');
        print(jsonDecode(response.body));
        // var res = response.body;
        // var jsonResponse = json.decode(res);
        // int code = jsonResponse['code'];
        // String message = jsonResponse['message'];
        // print(code);
        // print(message);
        Fluttertoast.showToast(
            msg: 'Error',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black);

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() =>
                SizedBox(
                  height: 600,
                  child: ListView.builder(

                    itemCount: controller.products.length,
                    itemBuilder: (context , index) =>
                        CartProductCard(
                          controller: controller,
                          product: controller.products.keys.toList()[index],
                          quantity: controller.products.values.toList()[index],
                          index: index,
                        ),
                  ),
                ),
            ),
            Center(
              child: Container(
                width: 350,
                height: 50,
                child: TextFormField(

                  decoration: InputDecoration(
                      labelText: "Comments",
                      hintText: "Comments",

                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                      //  child: Icon(Icons.email,),),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(1),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                        borderSide: BorderSide(color: Colors.black),
                        gapPadding: 10,)
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            _isLoading
                ?
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff292929),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color(0xffA8A8A8)),
                strokeWidth: 4,
              ),
            )
                :
            GestureDetector(
              onTap: (){
                if(controller.products.length == 0){
                  print('No items in cart');
                }
                else{
                  String productsData = jsonEncode(controller.products.keys.toList());
                  //ordersList.add(controller.products);
                  //List data = json.decode(controller.products.keys.toList());
                  print(productsData);
                  Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                  orderData(productsData);

                }
              },
              child: Container(
                height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.black
                  ),
                  child: Center(
                      child: Text('Create Order',style: TextStyle(color: Colors.white),))),
            ),
          ],
        ),
      ),
    );
  }
}


class CartProductCard extends StatefulWidget {

  final CartController controller;
  final OrderModel product;
  final int quantity;
  final int index;
  const CartProductCard({ Key? key, required this.controller, required this.product, required this.quantity, required this.index,}) : super(key: key);

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {

  late double itemTotalPrice;
  late double itemQuantity;
  late double itemPrice;

  @override
  Widget build(BuildContext context) {

    itemPrice = double.parse(widget.product.price.toString());
    assert(itemPrice is double);
    print(itemPrice);

    itemQuantity = double.parse(widget.quantity.toString());
    assert(itemQuantity is double);
    print(itemQuantity);

    itemTotalPrice = itemQuantity * itemPrice;

    if(widget.product.barcode!.contains('DEAL')){
      return
        GestureDetector(
          onTap: (){
            // showModalBottomSheet(context: context,
            //     backgroundColor: Colors.transparent,
            //     builder: (BuildContext context){
            //       return EditorWidget(itemName: widget.product.barcode,price: widget.product.price.toString(),);
            //     });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              color:   Color(0xFFFFFFFF),

              child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    'assets/images/placeholder.png',
                    height: 80,
                    width: 80,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(child: Text(widget.product.barcode!)),
                // SizedBox(width: 30,),
                Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                    child: Text('Rs: '+itemTotalPrice.toString() ,style: TextStyle(fontSize: 14),)),
                // IconButton(
                //   icon: Icon(Icons.remove),
                //   color: Color(0xFFC4996C),
                //   onPressed: () {
                //     // controller.removeProduct(product);
                //     widget.controller.decreaseCounterValue(widget.product);
                //   },
                // ),
                //
                // Text('${widget.quantity}'),
                //
                // IconButton(
                //   icon: Icon(Icons.add),
                //   color: Color(0xFFC4996C),
                //   onPressed: () {
                //     // controller.addProduct(product);
                //     widget.controller.addProduct(widget.product);
                //   },
                // ),
              ]),
            ),
          ),
        );
    }


    return
      GestureDetector(
        onTap: (){
          showModalBottomSheet(context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context){
                return EditorWidget(itemName: widget.product.barcode,price: widget.product.price.toString(),);
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            color:   Color(0xFFFFFFFF),

            child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/images/placeholder.png',
                  height: 80,
                  width: 80,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(child: Text(widget.product.barcode!)),
              // SizedBox(width: 30,),
              Text('Rs: '+itemTotalPrice.toString() ,style: TextStyle(fontSize: 14),),
              IconButton(
                icon: Icon(Icons.remove),
                color: Color(0xFFC4996C),
                onPressed: () {
                  // controller.removeProduct(product);
                  //widget.controller.decreaseCounterValue(widget.product);
                  setState(() {
                    if (widget.product.quantity != null)
                      widget.product.quantity = widget.product.quantity! - 1;
                    // widget.controller.addProduct(widget.product);
                  });
                  OrderModel _orderModel = OrderModel(
                      barcode: widget.product.barcode,
                      quantity: widget.product.quantity,
                      price: 420,
                      itemComment: 'testComment',
                      dealItems: []);
                  String orderData = jsonEncode(_orderModel);
                  print(orderData);
                  widget.controller.decreaseCounterValue(widget.product);
                },
              ),

              Text('${widget.quantity}'),

              IconButton(
                icon: Icon(Icons.add),
                color: Color(0xFFC4996C),
                onPressed: () {
                  // controller.addProduct(product);
                  //widget.controller.addProduct(widget.product);
                  setState(() {
                    if (widget.product.quantity != null)
                      widget.product.quantity = widget.product.quantity! + 1;
                    // widget.controller.addProduct(widget.product);
                  });
                  OrderModel _orderModel = OrderModel(
                      barcode: widget.product.barcode,
                      quantity: widget.product.quantity,
                      price: 420,
                      itemComment: 'testComment',
                      dealItems: []);
                  String orderData = jsonEncode(_orderModel);
                  print(orderData);
                  widget.controller.addProduct(widget.product);
                },
              ),
            ]),
          ),
        ),
      );

  }
}