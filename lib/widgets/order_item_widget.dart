import 'package:flutter/material.dart';
import 'package:shop/providers/orders.dart';
import 'dart:math';
import 'package:intl/intl.dart';

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
              title: Text("\$"+widget.orderItem.amount.toString(),),
              subtitle: Text(DateFormat("dd.MM.yyyy hh:mm").format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: _expanded? Icon(Icons.expand_less):Icon(Icons.expand_more),
                onPressed: (){
                  setState(() {
                    _expanded = !_expanded;
                    print(_expanded);
                  });
                },
              ),),
            if(_expanded)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                height: min(widget.orderItem.products.length*20.0+100, 100),
                child: ListView(

                    children: widget.orderItem.products.map((product) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.title,style:TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        Text('${product.quantity}X \$${product.price}',style:TextStyle(
                            fontSize: 18,
                            color: Colors.grey
                        ))


                      ],
                    )).toList()
                ),


              )


          ],
        ),

      ),
    );
  }
}
