import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';

import 'package:shop/screens/product_detail_screen.dart';
class ProductItem extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cartItem = Provider.of<Cart>(context,listen: false);
    print('listening');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),

      child: GridTile(

        child: GestureDetector(
          
          onTap: (){
           Navigator.pushNamed(context, ProductDetailScreen.routeName,arguments: product.id);
          },
          child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
      ),
        ),
      footer: GridTileBar(
        title: Text(product.title,

        textAlign: TextAlign.center,),
        backgroundColor: Colors.black54,
        leading: Consumer<Product>(
          builder: (context,product,child){
            print('listening_consumer');
            return IconButton(icon: Icon(

                product.isFavourite? Icons.favorite:Icons.favorite_border), onPressed: (){

              product.toggleFavourite();

            });
          },

        ),
        trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
          cartItem.addItem(product.id, product.title, product.price);

        }),

      ),
      ),
    );
  }
}
