import 'package:flutter/material.dart';


class CartItem {
  final String cartId;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.cartId, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  void addItem(String productID, String title, double price) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingCartItem) => CartItem(
              cartId: existingCartItem.cartId,
              price: existingCartItem.price,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity+1));
    }else{
      _items.putIfAbsent(productID,()=>CartItem(
        cartId: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1

      ));
    }
    notifyListeners();


  }

  Map<String, CartItem> get items => {..._items};

  int get getItemCount {
    int i = 0;
    _items.forEach((key, value) {
      i+=value.quantity;
    });
    return i;
  }

  double get getTotal {
    double i = 0;
    _items.forEach((key, value) {
      i+= value.price*value.quantity;
    });
    return i;
  }

  void removeItem(String productID){
    _items.remove(productID);
    notifyListeners();

  }

  void removeSingleItem(String productID){

      if(_items.containsKey(productID)){


        if(_items[productID].quantity>1){


          _items.update(

              productID,
                  (existingCartItem) => CartItem(
                  cartId: existingCartItem.cartId,
                  price: existingCartItem.price,
                  title: existingCartItem.title,
                  quantity: existingCartItem.quantity-1)
          );
        }else{
          _items.remove(productID);
        }
      }
      notifyListeners();

  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}
