


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/widgets/app_drawer.dart';

class ProductManageScreen extends StatelessWidget {
  static const routeName = '/product_manage_screen';
  @override
  Widget build(BuildContext context) {

   final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyProducts'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){

            },
          )
        ],

      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (context,index){
            return ProductWidget(
              product: products.items[index],
            );

          }),
    );
  }
}


class ProductWidget extends StatelessWidget {
 final Product product;


 ProductWidget({this.product});

 @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl)

        ),
        title: Text(
          product.title
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){

                },
              ),
              IconButton(
                icon:Icon(Icons.delete),
                onPressed: (){

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

