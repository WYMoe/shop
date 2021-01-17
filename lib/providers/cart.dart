import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/httpException.dart';

class CartItem {
  final String cartId;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.cartId, this.title, this.price, this.quantity});

  Map<String, dynamic> toJson() =>{
      'cartId': cartId,
      'title': title,
      'price': price,
      'quantity': quantity
    };

  factory CartItem.fromJson(Map<String,dynamic> map) {
    return CartItem(
      cartId: map['cartId'],
      price: map['price'],
      title: map['title'],
      quantity: map['quantity']

    );
  }

}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Future<void> addItem(String productID, String title, double price) async {
    try {
      if (_items.containsKey(productID)) {
        final url =
            "https://e-commerce-69833-default-rtdb.firebaseio.com/cart/$productID/${_items[productID].cartId}.json";
        await http.patch(url,
            body: jsonEncode({'quantity': _items[productID].quantity + 1}));
        _items.update(
            productID,
            (existingCartItem) => CartItem(
                cartId: existingCartItem.cartId,
                price: existingCartItem.price,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity + 1));
        notifyListeners();
      } else {
        final url =
            "https://e-commerce-69833-default-rtdb.firebaseio.com/cart/$productID.json";
        final response = await http.post(url,
            body: jsonEncode({'title': title, 'price': price, 'quantity': 1}));

        _items.putIfAbsent(
            productID,
            () => CartItem(
                cartId: jsonDecode(response.body)['name'],
                title: title,
                price: price,
                quantity: 1));
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Map<String, CartItem> get items => {..._items};

  Future<void> fetchCartItems() async {
    try {
      final url =
          "https://e-commerce-69833-default-rtdb.firebaseio.com/cart.json";

      final response = await http.get(url);
      Map<String, dynamic> cartProducts = jsonDecode(response.body);

      Map<String, CartItem> serverItem = {};
      if (cartProducts != null) {
        cartProducts.forEach((pID, cartJSONObj) {
          cartJSONObj.forEach((k, v) {
            CartItem c = CartItem(
                price: v['price'],
                title: v['title'],
                quantity: v['quantity'],
                cartId: k.toString());
            serverItem[pID] = c;
          });
        });
        _items.addAll(serverItem);
      }
//

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  int get getItemCount {
    int i = 0;
    _items.forEach((key, value) {
      i += value.quantity;
    });
    return i;
  }

  double get getTotal {
    double i = 0;
    _items.forEach((key, value) {
      i += value.price * value.quantity;
    });
    return i;
  }

  void removeItem(String productID) async {
    final url =
        "https://e-commerce-69833-default-rtdb.firebaseio.com/cart/$productID/${_items[productID].cartId}.json";
    var temp = _items[productID];
    _items.remove(productID);
    notifyListeners();
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items[productID] = temp;
      notifyListeners();
      throw HttpException();
    }
    temp = null;
  }

  void removeSingleItem(String productID) async {
    final url =
        "https://e-commerce-69833-default-rtdb.firebaseio.com/cart/$productID/${_items[productID].cartId}.json";
    if (_items.containsKey(productID)) {
      if (_items[productID].quantity > 1) {
        await http.patch(url,
            body: jsonEncode({'quantity': _items[productID].quantity - 1}));
        _items.update(
            productID,
            (existingCartItem) => CartItem(
                cartId: existingCartItem.cartId,
                price: existingCartItem.price,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1));
        notifyListeners();
      } else {
        var temp = _items[productID];
        _items.remove(productID);
        notifyListeners();
        var response = await http.delete(url);
        if (response.statusCode >= 400) {
          _items[productID] = temp;
          notifyListeners();
          throw HttpException();
        }
        temp = null;
      }
    }
  }

  void clear()async {
    final url =
        "https://e-commerce-69833-default-rtdb.firebaseio.com/cart.json";

    var temp = _items;
    _items = {};
    notifyListeners();

    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items = temp;
      notifyListeners();
      throw HttpException();
    }
    temp = null;

  }
}
