import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("MyCart"),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItemWidget(
                id: cart.items.keys.toList()[index],
                cartItem: cart.items.values.toList()[index],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  letterSpacing: 0.2),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '\$ ${cart.getTotal.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black,
                      ),
                      child: FlatButton(
                          onPressed: () {
                            orders.addOrder(
                                cart.getTotal, cart.items.values.toList());
                            cart.clear();
                          },
                          child: Text(
                            "Place Order",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            )
          ],
        ));
  }
}

class CartItemWidget extends StatelessWidget {
  // final String productID;
  // final String id;
  // final double price;
  // final String title;
  // final int quantity;
  //
  // CartItemWidget({this.productID,this.id, this.price, this.title, this.quantity});

  final CartItem cartItem;
  final String id;

  CartItemWidget({this.cartItem, this.id});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.cartId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove the item from the cart?'),
                actions: [
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            });
      },
      onDismissed: (direction) {
        return Provider.of<Cart>(context).removeItem(id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
        child: ListTile(

          leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey)),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('\$${cartItem.price} '),
                ),
              )),
          title: Text(cartItem.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total:\$${cartItem.quantity * cartItem.price}'),

            ],
          ),

          trailing: Text('X ${cartItem.quantity} '),
        ),
      ),
    );
  }
}
