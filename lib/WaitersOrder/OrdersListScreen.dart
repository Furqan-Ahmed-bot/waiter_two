import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/StarterData.dart';
import 'package:ts_app_development/UserControls/MasterWidget/ConfirmOrderDetailWidget.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      appBar: AppBar(
        title: Text(
          'Order Detail',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 600,
            child: ListView.builder(
              // itemCount: controller.products.length,
              itemCount: 5,
              itemBuilder: (context, index) => OrderListCard(
                // controller: controller,
                // product: controller.products.keys.toList()[index],
                // quantity: controller.products.values.toList()[index],
                // index: index,
              ),
            ),
          ),

          // SizedBox(height: 40,),
          // Text('Order Detail',style: TextStyle(color: Colors.black,fontSize: 24),textAlign: TextAlign.center,),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class OrderListCard extends StatefulWidget {
  // final CartController controller;
  // final StarterData product;
  // final int quantity;
  // final int index;
  const OrderListCard({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderListCard> createState() => _OrderListCardState();
}

class _OrderListCardState extends State<OrderListCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(ConfirmOrderWidget());

      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              color: Color(0xFFFFFFFF),

              child: Column(children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.list_alt , color: Color(0xFFb54f40),),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        'Order No: 1234',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),



                Row(

                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.table_bar_outlined , color: Color(0xFFb54f40),),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        'Table No: 210',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),


                  ],
                ),
                Row(

                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.date_range , color: Color(0xFFb54f40),),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        '${DateTime.now()}',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),


                  ],
                ),
              ]),

            ),
          ),

        ],
      ),
    );
    // Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Image.asset(widget.product.image,height: 70,width: 70,),
    //       Expanded(child: Text(widget.product.itemName)),
    //     ]
    // );
  }
}