
import 'package:flutter/material.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_manage_screen.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      
      child: Column(
        children: [
          AppBar(
            title:Text('Hello!'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,

          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: ListTile(
              leading: Icon(Icons.shop),
              title: Text('MyShop'),
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            Navigator.pushNamed(context, OrderScreen.routeName);
            },
            child: ListTile(
              leading: Icon(Icons.credit_card),
             title: Text('MyOrders'),
            ),
          ),

          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('ManageProducts'),
            ),
            onTap: (){

              Navigator.of(context).pushNamed(ProductManageScreen.routeName);


            },
          ),

        ],
      ),
    );
  }
}
