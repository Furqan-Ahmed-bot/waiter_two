import 'package:ts_app_development/DataLayer/Models/Orders/DealModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/Products.dart';
import 'package:get/get.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/StarterData.dart';

class CartController extends GetxController{
  var _products = {}.obs;

  var cartItems = <StarterData>[].obs;

  var numOfItems = 1.obs;

  var totalQuantity = 0.obs;

  void addProduct(OrderModel product){
    if(_products.containsKey(product)){
      _products[product] +=1;
    }
    else{
      _products[product] = product.quantity;
    }

    // Get.snackbar("Product Added" ,  "You Have Added the ${product.itemName} to the cart",
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: Duration(seconds: 1),
    // );
  }

  void removeProduct(OrderModel product){
    if(_products.containsKey(product) && _products[product] > 0){
      _products.removeWhere((key, value) => key == product);
    }
    else{
      print('Item Decrease: ${_products[product]}');
      print('Map Key: ${_products.containsKey(product)}');
      _products[product] -= 1;
    }
    //_products[product] -= 1;
  }

  void decreaseCounterValue(OrderModel product){
    if(_products.containsKey(product) && _products[product] == 1){
      _products.removeWhere((key, value) => key == product);
    }
    else{
      print('Item Decrease: ${_products[product]}');
      print('Map Key: ${_products.containsKey(product)}');
      _products[product] -= 1;
    }
    //_products[product] -= 1;
  }

  void addProductDeal(Items product){
    if(_products.containsKey(product)){
      _products[product] +=1;
    }
    else{
      _products[product] = product.counter;
    }

    // Get.snackbar("Product Added" ,  "You Have Added the ${product.itemName} to the cart",
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: Duration(seconds: 1),
    // );
  }

  void removeProductDeal(Items product){
    if(_products.containsKey(product) && _products[product] > 0){
      _products.removeWhere((key, value) => key == product);
    }
    else{
      _products[product] -= 1;
    }
    //_products[product] -= 1;
  }

  void addItemInCart(StarterData starterData){
    cartItems.add(starterData);
    totalQuantity.value = totalQuantity.value + numOfItems.value;
    numOfItems.value = 1;
  }

  void initializeQuantity(){
    numOfItems.value = 1;
  }

  get products => _products;




}