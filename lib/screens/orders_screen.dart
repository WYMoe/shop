

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:intl/intl.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item_widget.dart';
class OrderScreen extends StatefulWidget {

  static const routeName = 'order_screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(

      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),

      body: ListView.builder(
          itemCount: orders.orderItems.length,
          itemBuilder: (context,index){
        return OrderItemWidget(orderItem: orders.orderItems[index],);
      }),
    );
  }
}
