import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier{

  List<OrderItem> _orderItems = [
    
  ];
  
  void addOrder( double total,List<CartItem> products){
    
    _orderItems.insert(0, OrderItem(
      products: products,
      dateTime: DateTime.now(),
      amount: total,
      id: DateTime.now().toString()
    ));
    notifyListeners();
  }

  List<OrderItem> get orderItems => [..._orderItems];
}