import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/DealGroupItem.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/DealGroupModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/DealModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/StarterData.dart';
import 'package:ts_app_development/DataLayer/Providers/ThemeProvider/themeProvider.dart';
import 'package:ts_app_development/UserControls/MasterWidget/ConfirmOrderDetailWidget.dart';
import 'package:ts_app_development/UserControls/MasterWidget/DealWidget.dart';
import 'package:ts_app_development/UserControls/MasterWidget/EditorWidget.dart';
import 'package:ts_app_development/UserControls/PopUpDialog/popupDialog.dart';
import 'dart:convert';
import 'package:ts_app_development/WaitersOrder/cart_screen.dart';


class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OrdersPage> {

  List<DealModel>? dealModelList;
  List<DealModel>? dealModelListUpdated;

  List<DealGroupModel>? dealGroupModelList;
  List<DealGroupModel>? dealGroupModelListUpdated;

  List<DealItemModel>? dealItemModelList;
  List<DealItemModel>? dealItemModelListUpdated;

  var starterObjectsList = [];

  final cartController = Get.put(CartController());

  final CartController _cartController = Get.find();

  @override
  void initState() {
    fetchDealData();
    super.initState();
  }

  Future<void> fetchDealData() async{
    String url = 'http://10.1.1.13:8081/TSBE/EStore/Deal';
    var response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Basic dGVjaG5vc3lzOlRlY2g3MTA=',
        'TS-AppKey':'foodsinn'
      },
    );
    if(response.statusCode == 200)
    {
      print(jsonDecode(response.body));
      var res = response.body;
      var jsonResponse = json.decode(res);
      dealModelList = jsonDecode(response.body)
          .map((item) => DealModel.fromJson(item))
          .toList()
          .cast<DealModel>();

      print(dealModelList!.length);

      setState(() {
        dealModelListUpdated = dealModelList;
      });
      // homeScreenData = lastTransactions
      //     .map((item) => HomeBankScreenModel.fromJson(item))
      //     .toList()
      //     .cast<HomeBankScreenModel>();
      //
      // setState(() {
      //   homeScreenDataList = homeScreenData;
      // });
    }
    else
    {
      print(response.statusCode);
    }
  }


  List<StarterData> myList = [
    StarterData(
      itemName: 'Crunchy Finger Fish',
      itemPrice: '825',
      image: 'assets/images/placeholder.png'
    ),
    StarterData(
      itemName: 'Crunchy Fried Fish',
      itemPrice: '825',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
      itemName: 'Dynamite Prawns',
      itemPrice: '695',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Dynamite Chicken',
        itemPrice: '550',
        image: 'assets/images/placeholder.png'
    ),
  ];

  List<StarterData> myList1 = [
    StarterData(
        itemName: 'Classic Chicken Burger',
        itemPrice: '420',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Classic Beef Burger',
        itemPrice: '420',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Crispy Zinger Burger',
        itemPrice: '420',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'BBQ Chicken Burger',
        itemPrice: '480',
        image: 'assets/images/placeholder.png'
    ),
  ];

  List<StarterData> myList2 = [
    StarterData(
        itemName: 'Beef Steak Sandwich',
        itemPrice: '775',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Club Sandwich',
        itemPrice: '450',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'BBQ Club Sandwich',
        itemPrice: '495',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Malai Club Sandwich',
        itemPrice: '525',
        image: 'assets/images/placeholder.png'
    ),
  ];

  List<StarterData> myList3 = [
    StarterData(
        itemName: 'Kung Pao Chicken',
        itemPrice: '845',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Chicken Shashlik',
        itemPrice: '695',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Chicken Shashlik BBQ',
        itemPrice: '725',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Cherry Chilli Chicken',
        itemPrice: '870',
        image: 'assets/images/placeholder.png'
    ),
  ];

  List<StarterData> myList4 = [
    StarterData(
        itemName: 'Pepsi',
        itemPrice: '100',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: '7up',
        itemPrice: '100',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Mirinda',
        itemPrice: '100',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Mineral Water',
        itemPrice: '90',
        image: 'assets/images/placeholder.png'
    ),
  ];

  List<StarterData> myList5 = [
    StarterData(
        itemName: 'Deal 01',
        itemPrice: '400',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Deal 02',
        itemPrice: '400',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Deal 03',
        itemPrice: '400',
        image: 'assets/images/placeholder.png'
    ),
    StarterData(
        itemName: 'Deal 04',
        itemPrice: '400',
        image: 'assets/images/placeholder.png'
    ),
  ];

  //late Future<List<ItemData>> _future;

  // Future<List<ItemData>> _getProducts() async {
  //   var data = await http
  //       .get("https://orangecitycafe.in/app_configs/products_display.php");
  //
  //   var jsonData = json.decode(data.body);
  //   List<ItemData> details = [];
  //   for (var p in jsonData) {
  //     ItemData detail = ItemData(
  //         itemName: p["product_name"],
  //         itemPrice: p["product_price"],
  //         image: p["product_image"]);
  //     details.add(detail);
  //   }
  //   return details;
  // }

  // @override
  // void initState() {
  //   //_future = _getProducts();
  //   super.initState();
  // }

  Widget _myCart() {
          return ListView.builder(
            itemCount: myList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(myList[index].itemName),
                leading: Image.asset(
                    myList[index].image),
                trailing: myList[index].isAdded
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (myList[index].counter > 0) {
                            myList[index].counter--;
                          }
                        });
                      },
                      color: Colors.green,
                    ),
                    Text(myList[index].counter.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.green,
                      onPressed: () {
                        setState(() {
                          myList[index].counter++;
                        });
                      },
                    ),
                  ],
                )
                    : RaisedButton(
                  onPressed: () {
                    setState(() {
                      myList[index].isAdded = true;
                    });
                  },
                  child: Text("Add"),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {

    if (dealModelList == null && dealModelListUpdated == null) {
      return PopUpDialog(
        title: 'Awaiting Result',
        content: IntrinsicHeight(
          child: Column(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        onPressYes: () => {},
        isAction: false,
        isCloseBtn: false,
        isHeader: false,
      );
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 234, 234),
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ConfirmOrderWidget())));
              },
              icon: const Icon(
                Icons.edit_note,
                size: 30,
              ),
            ),
            Stack(
              children: [
                Badge(
                  position: BadgePosition.topEnd(top: 3, end: 3),
                  animationDuration: Duration(milliseconds: 300),
                  animationType: BadgeAnimationType.slide,
                  badgeColor: Colors.white,
                  toAnimate: true,
                  badgeContent: Obx(() => Text(_cartController.products.length.toString())),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Cart())));
                    },
                    icon: const Icon(
                      Icons.shopping_cart_rounded,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: ScrollableListTabView(
          tabHeight: 48,
          bodyAnimationDuration: const Duration(milliseconds: 150),
          tabAnimationCurve: Curves.easeOut,
          tabAnimationDuration: const Duration(milliseconds: 200),
          tabs: [
            ScrollableListTab(
                tab: const ListTab(
                    borderColor: Colors.transparent,
                    activeBackgroundColor: Colors.transparent,
                    inactiveBackgroundColor: Color(0xFFC4996C),
                    label: Text(
                      'Starters',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,),
                    ),
                    //activeBackgroundColor:  Color(0xFFb54f40),
                    borderRadius: BorderRadius.all(Radius.zero),
                    showIconOnList: false
                ),
                body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: myList1.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        showModalBottomSheet(context: context,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context){
                              return EditorWidget(itemName: myList1[index].itemName,price: myList1[index].itemPrice,);
                            });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Card(
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  height: 130,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Image.asset(
                                          myList1[index].image,
                                          height: 80,
                                          width: 80,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 20),
                                            child: Container(
                                              child: Text(
                                                myList1[index].itemName,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 40, 0),
                                            child: Container(
                                              height: 25,
                                              width: 80,
                                              child: Text(
                                                'Rs '+myList1[index].itemPrice,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap: (){
                                              if(myList1[index].counter == 0){
                                                print('No items selected');
                                              }
                                              else{
                                                //starterObjectsList.add(OrderModel(barcode: myList1[index].itemName,quantity: myList1[index].counter,price: 420,itemComment: 'testcomment'));
                                                //cartController.addProduct(myList1[index]);
                                                OrderModel _orderModel = OrderModel(barcode: myList1[index].itemName,quantity: myList1[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                                String orderData = jsonEncode(_orderModel);
                                                print(orderData);
                                                cartController.addProduct(_orderModel);
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black, borderRadius: BorderRadius.circular(0.0)
                                              ),
                                              child: Center(
                                                  child:
                                                  Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                              margin: EdgeInsets.only(left: 10,right: 10),
                                              height: 25,
                                              width: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            iconSize: 30,
                                            onPressed: () {
                                              setState(() {
                                                if (myList1[index].counter > 0) {
                                                  myList1[index].counter--;
                                                  print(myList1[index].counter);
                                                  if(myList1[index].counter == 0){
                                                    // OrderModel _orderModel = OrderModel(barcode: myList1[index].itemName,quantity: myList1[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                                    // String orderData = jsonEncode(_orderModel);
                                                    // print(orderData);
                                                    // cartController.removeProduct(_orderModel);
                                                    cartController.products.removeWhere(((item,value)=>item.barcode == myList1[index].itemName));
                                                    //cartController.removeProduct(myList1[index]);
                                                  }
                                                }
                                              });
                                            },
                                            color: Color(0xFFC4996C),
                                          ),
                                          Text(myList1[index].counter.toString()),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            iconSize: 30,
                                            color: Color(0xFFC4996C),
                                            onPressed: () {
                                              setState(() {
                                                myList1[index].counter++;
                                                //cartController.addProduct(myList1[index]);
                                                if(myList1[index].counter == 0){
                                                  print('No items selected');
                                                }
                                                else{
                                                  //cartController.addProduct(myList1[index]);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                              elevation: 10,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
            ),
            ScrollableListTab(
              tab: ListTab(
                  borderColor: Colors.transparent,
                  activeBackgroundColor: Colors.transparent,
                  inactiveBackgroundColor: Color(0xFFC4996C),
                  label: Text(
                    'Burgers',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,),
                  ),
                  //activeBackgroundColor:  Color(0xFFb54f40),
                  borderRadius: BorderRadius.all(Radius.zero),
                  showIconOnList: false
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: myList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      showModalBottomSheet(context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context){
                            return EditorWidget(itemName: myList[index].itemName,price: myList[index].itemPrice,);
                          });
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFFFFFFF),
                                ),

                                height: 130,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        myList[index].image,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 20),
                                          child: Container(
                                            child: Text(
                                              myList[index].itemName,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 40, 0),
                                          child: Container(
                                            height: 25,
                                            width: 80,
                                            child: Text(
                                              'Rs '+myList[index].itemPrice,
                                              style: TextStyle(
                                                  color: Colors.black,
                                              fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: (){
                                            if(myList[index].counter == 0){
                                              print('No items selected');
                                            }
                                            else{
                                              //cartController.addProduct(myList[index]);
                                              OrderModel _orderModel = OrderModel(barcode: myList[index].itemName,quantity: myList[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                              String orderData = jsonEncode(_orderModel);
                                              print(orderData);
                                              cartController.addProduct(_orderModel);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(0.0)
                                            ),
                                            child: Center(
                                                child:
                                                Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                            margin: EdgeInsets.only(left: 10,right: 10),
                                            height: 25,
                                            width: 100,
                                          ),
                                        ),
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
                                              if (myList[index].counter > 0) {
                                                myList[index].counter--;
                                                if(myList[index].counter == 0){
                                                  //cartController.removeProduct(myList[index]);
                                                  // OrderModel _orderModel = OrderModel(barcode: myList[index].itemName,quantity: myList[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                                  // String orderData = jsonEncode(_orderModel);
                                                  // print(orderData);
                                                  // cartController.removeProduct(_orderModel);
                                                  cartController.products.removeWhere(((item,value)=>item.barcode == myList[index].itemName));
                                                }
                                              }
                                            });
                                          },
                                          color: Color(0xFFC4996C),
                                        ),
                                        Text(myList[index].counter.toString()),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          iconSize: 30,
                                          color: Color(0xFFC4996C),
                                          onPressed: () {
                                            setState(() {
                                              myList[index].counter++;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                            elevation: 10,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                  borderColor: Colors.transparent,
                  activeBackgroundColor: Colors.transparent,
                  inactiveBackgroundColor: Color(0xFFC4996C),
                  label: Text(
                    'Sandwiches',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,),
                  ),
                  //activeBackgroundColor:  Color(0xFFb54f40),
                  borderRadius: BorderRadius.all(Radius.zero),
                  showIconOnList: false
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: myList2.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      showModalBottomSheet(context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context){
                            return EditorWidget(itemName: myList2[index].itemName,price: myList2[index].itemPrice,);
                          });
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFFFFFFF),
                                ),

                                height: 130,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        myList2[index].image,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 20),
                                          child: Container(
                                            child: Text(
                                              myList2[index].itemName,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 40, 0),
                                          child: Container(
                                            height: 25,
                                            width: 80,
                                            child: Text(
                                              'Rs '+myList2[index].itemPrice,
                                              style: TextStyle(
                                                  color: Colors.black,
                                              fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: (){
                                            if(myList2[index].counter == 0){
                                              print('No items selected');
                                            }
                                            else{
                                              //cartController.addProduct(myList2[index]);
                                              OrderModel _orderModel = OrderModel(barcode: myList2[index].itemName,quantity: myList2[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                              String orderData = jsonEncode(_orderModel);
                                              print(orderData);
                                              cartController.addProduct(_orderModel);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(0.0)
                                            ),
                                            child: Center(
                                                child:
                                                Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                            margin: EdgeInsets.only(left: 10,right: 10),
                                            height: 25,
                                            width: 100,
                                          ),
                                        ),
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
                                              if (myList2[index].counter > 0) {
                                                myList2[index].counter--;
                                                if(myList2[index].counter == 0){
                                                  //cartController.removeProduct(myList2[index]);
                                                  // OrderModel _orderModel = OrderModel(barcode: myList2[index].itemName,quantity: myList2[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                                  // String orderData = jsonEncode(_orderModel);
                                                  // print(orderData);
                                                  // cartController.removeProduct(_orderModel);
                                                  cartController.products.removeWhere(((item,value)=>item.barcode == myList2[index].itemName));
                                                }
                                              }
                                            });
                                          },
                                          color: Color(0xFFC4996C),
                                        ),
                                        Text(myList2[index].counter.toString()),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          iconSize: 30,
                                          color: Color(0xFFC4996C),
                                          onPressed: () {
                                            setState(() {
                                              myList2[index].counter++;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                            elevation: 10,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                  borderColor: Colors.transparent,
                  activeBackgroundColor: Colors.transparent,
                  inactiveBackgroundColor: Color(0xFFC4996C),
                  label: Text(
                    'Chinese',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,),
                  ),
                  //activeBackgroundColor:  Color(0xFFb54f40),
                  borderRadius: BorderRadius.all(Radius.zero),
                  showIconOnList: false
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: myList3.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      showModalBottomSheet(context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context){
                            return EditorWidget(itemName: myList3[index].itemName,price: myList3[index].itemPrice,);
                          });
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFFFFFFF),
                                ),

                                height: 130,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        myList3[index].image,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 20),
                                          child: Container(
                                            child: Text(
                                              myList3[index].itemName,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 40, 0),
                                          child: Container(
                                            height: 25,
                                            width: 80,
                                            child: Text(
                                              'Rs '+myList3[index].itemPrice,
                                              style: TextStyle(
                                                  color: Colors.black,
                                              fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: (){
                                            if(myList3[index].counter == 0){
                                              print('No items selected');
                                            }
                                            else{
                                             // cartController.addProduct(myList3[index]);
                                              OrderModel _orderModel = OrderModel(barcode: myList3[index].itemName,quantity: myList3[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                              String orderData = jsonEncode(_orderModel);
                                              print(orderData);
                                              cartController.addProduct(_orderModel);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(0.0)
                                            ),
                                            child: Center(
                                                child:
                                                Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                            margin: EdgeInsets.only(left: 10,right: 10),
                                            height: 25,
                                            width: 100,
                                          ),
                                        ),
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
                                              if (myList3[index].counter > 0) {
                                                myList3[index].counter--;
                                                if(myList3[index].counter == 0){
                                                  //cartController.removeProduct(myList3[index]);
                                                  // OrderModel _orderModel = OrderModel(barcode: myList3[index].itemName,quantity: myList3[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                                  // String orderData = jsonEncode(_orderModel);
                                                  // print(orderData);
                                                  // cartController.removeProduct(_orderModel);
                                                  cartController.products.removeWhere(((item,value)=>item.barcode == myList3[index].itemName));
                                                }
                                              }
                                            });
                                          },
                                          color: Color(0xFFC4996C),
                                        ),
                                        Text(myList3[index].counter.toString()),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          iconSize: 30,
                                          color: Color(0xFFC4996C),
                                          onPressed: () {
                                            setState(() {
                                              myList3[index].counter++;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                            elevation: 10,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                  borderColor: Colors.transparent,
                  activeBackgroundColor: Colors.transparent,
                  inactiveBackgroundColor: Color(0xFFC4996C),
                  label: Text(
                    'Beverages',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,),
                  ),
                  //activeBackgroundColor:  Color(0xFFb54f40),
                  borderRadius: BorderRadius.all(Radius.zero),
                  showIconOnList: false
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: myList4.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      showModalBottomSheet(context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context){
                            return EditorWidget(itemName: myList4[index].itemName,price: myList4[index].itemPrice,);
                          });
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFFFFFFF),
                                ),

                                height: 130,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        myList4[index].image,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 20),
                                          child: Container(
                                            child: Text(
                                              myList4[index].itemName,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 40, 0),
                                          child: Container(
                                            height: 25,
                                            width: 80,
                                            child: Text(
                                              'Rs '+myList4[index].itemPrice,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: (){
                                            if(myList4[index].counter == 0){
                                              print('No items selected');
                                            }
                                            else{
                                              //cartController.addProduct(myList4[index]);
                                              OrderModel _orderModel = OrderModel(barcode: myList4[index].itemName,quantity: myList4[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                              String orderData = jsonEncode(_orderModel);
                                              print(orderData);
                                              cartController.addProduct(_orderModel);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(0.0)
                                            ),
                                            child: Center(
                                                child:
                                                Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                            margin: EdgeInsets.only(left: 10,right: 10),
                                            height: 25,
                                            width: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: (){setState(() {
                                              setState(() {
                                                if (myList4[index].counter > 0) {
                                                  myList4[index].counter--;
                                                  print(myList4[index].counter);
                                                  if (myList4[index].counter ==
                                                      0) {
                                                    // cartController.removeProduct(
                                                    //     myList4[index]);
                                                    // OrderModel _orderModel = OrderModel(barcode: myList4[index].itemName,quantity: myList4[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                                    // String orderData = jsonEncode(_orderModel);
                                                    // print(orderData);
                                                    // cartController.removeProduct(_orderModel);
                                                    cartController.products.removeWhere(((item,value)=>item.barcode == myList4[index].itemName));
                                                  }
                                                }
                                              });
                                            }); },
                                            onDoubleTap: (){setState(() {
                                              setState(() {
                                                if (myList4[index].counter >= 5) {
                                                  myList4[index].counter-=5;
                                                  print(myList4[index].counter);
                                                  if (myList4[index].counter ==
                                                      0) {
                                                    // cartController.removeProduct(
                                                    //     myList4[index]);
                                                    // OrderModel _orderModel = OrderModel(barcode: myList4[index].itemName,quantity: myList4[index].counter,price: 420,itemComment: 'testComment',dealItems: []);
                                                    // String orderData = jsonEncode(_orderModel);
                                                    // print(orderData);
                                                    // cartController.removeProduct(_orderModel);
                                                    cartController.products.removeWhere(((item,value)=>item.barcode == myList4[index].itemName));
                                                  }
                                                }
                                              });
                                            }); },
                                            child: Container(
                                              child: Icon(
                                                Icons.remove,
                                                color: Color(0xFFC4996C),
                                                size: 30,
                                              ),
                                            )),
                                        SizedBox(width: 10,),
                                        Text(myList4[index].counter.toString()),
                                        SizedBox(width: 10,),
                                        GestureDetector(
                                            onTap: (){setState(() {
                                              myList4[index].counter ++;
                                            }); },
                                            onDoubleTap: (){setState(() {
                                              myList4[index].counter += 5;
                                            }); },
                                            child: Container(
                                              child: Icon(
                                                Icons.add,
                                                color: Color(0xFFC4996C),
                                                size: 30,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            elevation: 10,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            ScrollableListTab(
              tab: ListTab(
                  borderColor: Colors.transparent,
                  activeBackgroundColor: Colors.transparent,
                  inactiveBackgroundColor: Color(0xFFC4996C),
                  label: Text(
                    'Deals',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,),
                  ),
                  //activeBackgroundColor:  Color(0xFFb54f40),
                  borderRadius: BorderRadius.all(Radius.zero),
                  showIconOnList: false
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dealModelListUpdated!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      showModalBottomSheet(context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context){
                            return DealWidget(
                              itemName: dealModelListUpdated![index].deal,
                              price: dealModelListUpdated![index].saleRate.toString(),
                            dealList: dealModelListUpdated![index].itemgroups,
                            );
                          });
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFFFFFFF),
                                ),

                                height: 130,
                                child: Row(
                                  children: [
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
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 20),
                                          child: Container(
                                            child: Text(
                                              '${dealModelListUpdated![index].deal}',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 40, 0),
                                          child: Container(
                                            height: 25,
                                            width: 80,
                                            child: Text(
                                              'Rs '+'${dealModelListUpdated![index].saleRate}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     // if(myList5[index].counter == 0){
                                        //     //   print('No items selected');
                                        //     // }
                                        //     // else{
                                        //     //   cartController.addProduct(myList5[index]);
                                        //     // }
                                        //   },
                                        //   child: Container(
                                        //     decoration: BoxDecoration(
                                        //         color: Colors.black,
                                        //         borderRadius: BorderRadius.circular(0.0)
                                        //     ),
                                        //     child: Center(
                                        //         child:
                                        //         Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                        //     margin: EdgeInsets.only(left: 10,right: 10),
                                        //     height: 25,
                                        //     width: 100,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Spacer(),
                                    // Row(
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   children: <Widget>[
                                    //     IconButton(
                                    //       icon: Icon(Icons.remove),
                                    //       iconSize: 30,
                                    //       onPressed: () {
                                    //         setState(() {
                                    //           if (dealModelListUpdated![index].counter > 0) {
                                    //             dealModelListUpdated![index].counter--;
                                    //             if(dealModelListUpdated![index].counter == 0){
                                    //               //cartController.removeProduct(myList5[index]);
                                    //             }
                                    //           }
                                    //         });
                                    //       },
                                    //       color: Color(0xFFC4996C),
                                    //     ),
                                    //     Text(dealModelListUpdated![index].counter.toString()),
                                    //     IconButton(
                                    //       icon: Icon(Icons.add),
                                    //       iconSize: 30,
                                    //       color: Color(0xFFC4996C),
                                    //       onPressed: () {
                                    //         setState(() {
                                    //           dealModelListUpdated![index].counter++;
                                    //         });
                                    //       },
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                )
                            ),
                            elevation: 10,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),

    );
  }
}

// class CatalogProduct extends StatelessWidget {
//   final cartController = Get.put(CartController());
//   final int index;
//
//   CatalogProduct({ Key? key, required this.index }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(padding: EdgeInsets.symmetric(
//       horizontal: 20,
//       vertical: 10,
//     ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundImage: NetworkImage(Product.products[index].imageUrl),
//           ),
//           SizedBox(width: 20,),
//           Expanded(child: Text(Product.products[index].name)),
//           Expanded(child: Text('${Product.products[index].price}')),
//           IconButton(onPressed: () {
//             cartController.addProduct(Product.products[index]);
//           },
//               icon: Icon(Icons.add_circle)),
//
//         ],
//       ),);
//   }
// }