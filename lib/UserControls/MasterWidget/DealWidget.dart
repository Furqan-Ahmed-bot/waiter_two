import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/DealGroupModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/DealModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/DealSave.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';

class DealWidget extends StatefulWidget {
  final String? itemName;
  final String? price;
  final List<Itemgroups>? dealList;
  const DealWidget({Key? key,required this.itemName,required this.price, required this.dealList}) : super(key: key);

  @override
  State<DealWidget> createState() => _DealWidgetState();
}

class _DealWidgetState extends State<DealWidget> {

  String _groupValue = '';
  double counter = 0.0;
  double? quantity;
  String? strQuantity;
  List<DealSave> jsonObjectsList = [];
  bool _flag = true;

  final cartController = Get.put(CartController());

  void checkRadio(String value ) {
    setState(() {
      _groupValue = value;
    });
  }

  List multipleSelected = [];
  List checkListItems = [
    {
      "id": 0,
      "value": false,
      "title": "Pepsi",
    },
    {
      "id": 1,
      "value": false,
      "title": "7up",
    },
    {
      "id": 2,
      "value": false,
      "title": "Mirinda",
    },
  ];

  @override
  bool value = false;
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: 800,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,

                    child: Image.asset('assets/images/placeholder.png',
                        fit: BoxFit.fill),
                    //         decoration: new BoxDecoration(
                    //   color: Colors.transparent,
                    //   borderRadius: BorderRadius.vertical(
                    //       bottom: Radius.elliptical(
                    //           MediaQuery.of(context).size.width, 70.0)),
                    // ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Text(
                      widget.itemName!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                    child: Text(
                      widget.price!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Text('Description'),
              ),
              Center(
                child: Container(
                  width: 350,
                  child: Divider(
                    height: 10,
                    thickness: 1,
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.dealList!.length,
                  itemBuilder: (BuildContext context,int index) {

                    quantity = widget.dealList![index].quantity;

                    print(quantity);

                    strQuantity = quantity!.toInt().toString();

                    print(strQuantity);

                    // var arr = strQuantity!.split('.');
                    // print(arr[0]);
                    // print(arr[1]);

                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text('${widget.dealList![index].quantity}'),
                          // Text('${widget.dealList![index].multiSelection}'),
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              children: [
                                Text('Group: '+'${widget.dealList![index].itemGroupId}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                Spacer(),
                                Text('0',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('/',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('${widget.dealList![index].quantity}',style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          //Text('Group: '+'${widget.dealList![index].itemGroupId}'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.dealList![index].items!.length,
                            itemBuilder: (BuildContext context,int index1){
                              return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                child: Column(
                                  children: [
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 10,right: 10),
                                    //   child: Row(
                                    //     children: [
                                    //       Text('Group: '+'${widget.dealList![index].itemGroupId}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                    //       Spacer(),
                                    //       Text('0',style: TextStyle(fontWeight: FontWeight.bold),),
                                    //       Text('/',style: TextStyle(fontWeight: FontWeight.bold),),
                                    //       Text('${widget.dealList![index].quantity}',style: TextStyle(fontWeight: FontWeight.bold),)
                                    //     ],
                                    //   ),
                                    // ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 20),
                                              child: Container(
                                                child: Text(
                                                  '${widget.dealList![index].items![index1].product}',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              iconSize: 30,
                                              onPressed: () {
                                                setState(() {
                                                  if (widget.dealList![index].counter > 0) {
                                                    widget.dealList![index].counter--;
                                                    widget.dealList![index].items![index1].counter--;
                                                    jsonObjectsList.removeWhere((item) => item.barcode == widget.dealList![index].items![index1].barcode);
                                                    print('List Size: ${jsonObjectsList.length}');
                                                    //counter = widget.dealList![index].items![index1].counter;
                                                    // if(widget.dealList![index].counter == 0){
                                                    //   cartController.removeProductDeal(widget.dealList![index].items![index1]);
                                                    // }
                                                  }
                                                });
                                              },
                                              color: Color(0xFFC4996C),
                                            ),
                                            Text(widget.dealList![index].items![index1].counter.toString()),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              iconSize: 30,
                                              color: Color(0xFFC4996C),
                                              onPressed: () {
                                                setState(() {
                                                  if(widget.dealList![index].counter.toString() == widget.dealList![index].quantity.toString()){
                                                    print('Limit reached for that group...');
                                                    Fluttertoast.showToast(
                                                        msg: "Limit reached for that group...",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0
                                                    );
                                                  }
                                                  else{
                                                    widget.dealList![index].counter++;
                                                    widget.dealList![index].items![index1].counter++;
                                                    jsonObjectsList.add(DealSave(ItemGroupId: widget.dealList![index].itemGroupId,barcode: widget.dealList![index].items![index1].barcode,Quantity: widget.dealList![index].quantity));
                                                    print('List Size: ${jsonObjectsList.length}');
                                                    //counter = widget.dealList![index].items![index1].counter;
                                                    //cartController.addProductDeal(widget.dealList![index].items![index1]);
                                                  }
                                                  // if(strQuantity == widget.dealList![index].items![index1].counter.toString()){
                                                  //   print('Limit Reached...');
                                                  // }
                                                  // else if(counter < 1){
                                                  //   widget.dealList![index].items![index1].counter++;
                                                  //   counter = widget.dealList![index].items![index1].counter;
                                                  // }
                                                  // else{
                                                  //   widget.dealList![index].items![index1].counter++;
                                                  //   counter = widget.dealList![index].items![index1].counter;
                                                  // }
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  }),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              //       child: Text(
              //         widget.itemName,
              //         style: TextStyle(fontSize: 20),
              //       ),
              //     ),
              //   ],
              // ),
              // RadioListTile(
              //     value: 'Chicken Burger',
              //     title: Text('Chicken Burger',style: TextStyle(color: Colors.black),),
              //     groupValue: _groupValue,
              //     onChanged: (value) {
              //       checkRadio(value as String);
              //     }
              // ),
              // RadioListTile(
              //     value: 'Leg Broast',
              //     title: Text('Leg Broast',style: TextStyle(color: Colors.black),),
              //     groupValue: _groupValue,
              //     onChanged: (value) {
              //       checkRadio(value as String);
              //     }
              // ),
              // RadioListTile(
              //     value: 'Chest Broast',
              //     title: Text('Chest Broast',style: TextStyle(color: Colors.black),),
              //     groupValue: _groupValue,
              //     onChanged: (value) {
              //       checkRadio(value as String);
              //     }
              // ),
              // Divider(),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              //   child: Text(
              //     widget.itemName,
              //     style: TextStyle( fontSize: 20),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 8),
              //   child: Column(
              //     children: List.generate(
              //       checkListItems.length,
              //           (index) => CheckboxListTile(
              //         controlAffinity: ListTileControlAffinity.leading,
              //         contentPadding: EdgeInsets.zero,
              //         dense: true,
              //         title: Text(
              //           checkListItems[index]["title"],
              //           style: const TextStyle(
              //             fontSize: 16.0,
              //             color: Colors.black,
              //           ),
              //         ),
              //         value: checkListItems[index]["value"],
              //         onChanged: (value) {
              //           setState(() {
              //             checkListItems[index]["value"] = value;
              //             if (multipleSelected.contains(checkListItems[index])) {
              //               multipleSelected.remove(checkListItems[index]);
              //             } else {
              //               multipleSelected.add(checkListItems[index]);
              //             }
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              // customAddsonn('Pepsi'),
              // customAddsonn('7up'),
              // customAddsonn('Mirinda'),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text(
                  'Comments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Text(
                  '(Please let us know if we need to avoid anything)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),

              // TextFormField(
              //   decoration: InputDecoration(
              //     hintText: ('eg no mayo'),


              //   ),
              // ),
              SizedBox(height: 20,),
              Center(
                child: Container(
                  width: 350,
                  height: 50,
                  child: TextFormField(

                    decoration: InputDecoration(
                        labelText: "no mayo",
                        hintText: "eg. no mayo",

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
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  if(jsonObjectsList != null){
                    //cartController.addProduct(jsonObjectsList);
                    OrderModel _orderModel = OrderModel(barcode: widget.itemName,quantity: 1,price: 420,itemComment: 'testComment',dealItems: jsonObjectsList);
                    String orderData = jsonEncode(_orderModel);
                    print(orderData);
                    cartController.addProduct(_orderModel);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 15,right: 15),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Center(child: Text('Add to Table',style: TextStyle(color: Colors.white),)),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Row customAddsonn(String txt) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 0),
          child: Checkbox(
            value: this.value,
            onChanged: (value) {
              setState(() {
                this.value = value!;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            txt,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

}