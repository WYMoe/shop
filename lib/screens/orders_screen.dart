import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:intl/intl.dart';
import 'package:shop/widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'order_screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
          itemBuilder: (context, index) {
            return OrderItemWidget(
              orderItem: orders.orderItems[index],
            );
          }),
    );
  }
}

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemWidget({this.orderItem});
  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "\$" + widget.orderItem.amount.toString(),
              ),
              subtitle: Text(DateFormat("dd.MM.yyyy")
                  .add_jm()
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                    print(_expanded);
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: min(widget.orderItem.products.length * 20.0 + 100, 100),
                child: ListView(
                    children: widget.orderItem.products
                        .map((product) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${product.quantity} X \$${product.price}',
                                    style: TextStyle(color: Colors.grey))
                              ],
                            ))
                        .toList()),
              )
          ],
        ),
      ),
    );
  }
}
