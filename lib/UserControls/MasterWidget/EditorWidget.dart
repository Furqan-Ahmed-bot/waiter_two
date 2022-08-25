import 'package:flutter/material.dart';

class EditorWidget extends StatefulWidget {
  final String? itemName;
  final String price;
  const EditorWidget({Key? key,required this.itemName,required this.price}) : super(key: key);

  @override
  State<EditorWidget> createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<EditorWidget> {
  @override
  bool value = false;
  bool value2 = false;
  bool value3 = false;
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
                      widget.price,
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              //       child: Text(
              //         'Modifiers',
              //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
              //       child: Container(
              //           width: 70,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.grey[400],
              //           ),
              //           child: Center(
              //               child: Text(
              //                 'Optional',
              //                 style: TextStyle(
              //                     fontSize: 13,
              //                     fontWeight: FontWeight.bold,
              //                     color: Color.fromARGB(255, 71, 70, 70)),
              //               ))),
              //     )
              //   ],
              // ),
              // customAddsonn('Extra Topping',Checkbox(
              //   value: this.value,
              //   onChanged: (value) {
              //     setState(() {
              //       this.value = value!;
              //     });
              //   },
              // ),),
              // customAddsonn('Extra Chicken',Checkbox(
              //   value: this.value2,
              //   onChanged: (value) {
              //     setState(() {
              //       this.value2 = value!;
              //     });
              //   },
              // ),),
              // customAddsonn('Extra Cheese',Checkbox(
              //   value: this.value3,
              //   onChanged: (value) {
              //     setState(() {
              //       this.value3 = value!;
              //     });
              //   },
              // ),),

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
              SizedBox(height: 10,)


            ],
          ),
        ),
      ),
    );
  }

  Row customAddsonn(String txt,Checkbox chk) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 0),
          child: chk
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            txt,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Spacer(),
        Padding(
            padding: const EdgeInsets.fromLTRB(110, 0, 15, 0),
            child: Text('+ 150')
        )
      ],
    );
  }
}