import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'OrderScreen.dart';

class SelectTable extends StatefulWidget {
  const SelectTable({Key? key}) : super(key: key);

  @override
  State<SelectTable> createState() => _SelectTableState();
}

class _SelectTableState extends State<SelectTable> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      appBar: AppBar(title: Text('Select Table')),
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
                // borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Text('Enter Table No' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20)),
                  SizedBox(height: 30,),
                  Container(
                    width: 250,
                    child: TextFormField(
                      decoration: InputDecoration(

                          hintText: "Table No",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                          //  child: Icon(Icons.email,),),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10,
                          )),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Fields must not be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: (){
                        if (formKey.currentState!.validate()){
                          Get.to(OrdersPage(title: 'Menu Screen',));
                        }
                        else{
                          // Fluttertoast.showToast(
                          //     msg: 'Fields must not be empty',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     backgroundColor: Colors.white,
                          //     textColor: Colors.black);
                        }
                        }, child: Text(' OK '))
                ],
              )),
        ),
      ),
    );
  }
}