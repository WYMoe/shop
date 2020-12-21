
import 'package:flutter/material.dart';
import 'package:shop/screens/orders_screen.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      
      child: Column(
        children: [
          AppBar(
            title:Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, '/');
            },
            child: ListTile(
              leading: Icon(Icons.shop),
              title: Text('MyShop'),
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: (){
            Navigator.pushNamed(context, OrderScreen.routeName);
            },
            child: ListTile(
              leading: Icon(Icons.credit_card),
             title: Text('MyOrders'),
            ),
          )
        ],
      ),
    );
  }
}
