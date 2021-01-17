import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.cartItems, this.dateTime});

  Map<String, dynamic> toJson() {
    List<Map> cartItems = this.cartItems != null
        ? this.cartItems.map((i) => i.toJson()).toList()
        : null;

    return {
      'amount': amount,
      'cartItems': cartItems,
      'datetime': dateTime.toIso8601String()
    };
  }
  factory OrderItem.fromJson(String id,Map<String,dynamic> map){
    List<dynamic> list = map['cartItems'];
    List<CartItem> cartItems = list.map((e) =>CartItem.fromJson(e) ).toList();

    return OrderItem(
      id: id,
      cartItems: cartItems,
      dateTime: DateTime.parse(map['datetime']),
      amount: map['amount']
    );
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  Future<void> addOrder(double total, List<CartItem> cartItems) async {

    try {
      final url =
          "https://e-commerce-69833-default-rtdb.firebaseio.com/order.json";

      DateTime dateTime = DateTime.now();
      var orderItem = OrderItem(
          amount: total, dateTime: dateTime, cartItems: cartItems);

      var response = await http.post(url, body: jsonEncode(orderItem));
      print(response.body);

      _orderItems.insert(
          0,
          OrderItem(
              cartItems: cartItems,
              dateTime: dateTime,
              amount: total,
              id: jsonDecode(response.body)['name']));
      notifyListeners();
    }catch(error){
      print(error);
    }
  }
  
  Future<void> fetchOrders()async{



    try {
      final url =
          "https://e-commerce-69833-default-rtdb.firebaseio.com/order.json";

      var response = await http.get(url);

      Map<String, dynamic> decodedJson = jsonDecode(response.body);
      List<OrderItem> orders = [];

      decodedJson.forEach((key, value) {
        orders.add(OrderItem.fromJson(key, value));
      });
      _orderItems = orders.reversed.toList();

      notifyListeners();
    }catch(error){
      print(error);
    }
    
    
    
    
  }
  


  List<OrderItem> get orderItems => [..._orderItems];
}
