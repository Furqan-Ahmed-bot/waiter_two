import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../WaitersOrder/OrderScreen.dart';
import '../../WaitersOrder/orders.dart';

class ConfirmOrderWidget extends StatefulWidget {
  const ConfirmOrderWidget({Key? key}) : super(key: key);

  @override
  State<ConfirmOrderWidget> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Order')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // height: 800,
            decoration: const BoxDecoration(

              // color: Color.fromARGB(255, 240, 234, 234),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            // appBar: AppBar(title: Text('Edit Orders'),),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    SizedBox(width: 100,),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 105,),
                    Icon(Icons.table_bar_outlined , color: Color(0xFFb54f40),),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        'Table No: 210',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),


                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                            'Edit Orders',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(OrdersPage(
                            title: '',
                          ));
                        },
                        child: Container(
                          color: Color(0xFFb54f40),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Container(
                    height: 100,
                    // color:  Color(0xFFFFFFFF),
                    color: Color.fromARGB(255, 240, 234, 234),

                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              'assets/images/placeholder.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                          // CircleAvatar(
                          //   radius: 40,
                          //   backgroundImage: Image.asset(
                          //       product.image.toString()
                          //   ),
                          // ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(child: Text('BBQ Club Sandwich')),
                          // Spacer(),
                          Text('Rs: 399'),
                          SizedBox(
                            width: 10,
                          ),

                          IconButton(
                            icon: Icon(Icons.remove),
                            color: Color(0xFFC4996C),
                            onPressed: () {
                              // controller.removeProduct(product);
                            },
                          ),

                          Text('5'),

                          IconButton(
                            icon: Icon(Icons.add),
                            color: Color(0xFFC4996C),
                            onPressed: () {
                              // controller.addProduct(product);
                            },
                          ),
                        ]),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Container(
                      height: 100,
                      // color: Colors.white,
                      color: Color.fromARGB(255, 240, 234, 234),

                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Image.asset(
                                'assets/images/placeholder.png',
                                height: 80,
                                width: 80,
                              ),
                            ),
                            // CircleAvatar(
                            //   radius: 40,
                            //   backgroundImage: Image.asset(
                            //       product.image.toString()
                            //   ),
                            // ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(child: Text('Food Name')),
                            // Spacer(),
                            Text('Rs: 399'),
                            SizedBox(
                              width: 8,
                            ),

                            IconButton(
                              icon: Icon(Icons.remove),
                              color: Color(0xFFC4996C),
                              onPressed: () {
                                // controller.removeProduct(product);
                              },
                            ),

                            Text('5'),

                            IconButton(
                              icon: Icon(Icons.add),
                              color: Color(0xFFC4996C),
                              onPressed: () {
                                // controller.addProduct(product);
                              },
                            ),
                          ]),
                    )),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       child: ElevatedButton(onPressed: (){},
                //         child: Text('Update Order'),),
                //     ),

                //     SizedBox(width: 20,),

                //     Container(
                //       child: ElevatedButton(onPressed: (){
                //         Get.to(OrdersPage(title: '',));
                //       },
                //         child: Text('Add Order'),),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}