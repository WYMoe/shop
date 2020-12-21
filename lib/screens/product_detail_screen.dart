
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .getByID(productID);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,

            ),
            SizedBox(height: 10.0,),
            Text('\$ ${loadedProduct.price}',
              style: TextStyle(
                  fontSize: 18.0,
                color: Colors.grey
              ),),
            SizedBox(height: 10.0,),
            Text(loadedProduct.description,
              style: TextStyle(
                fontSize: 20.0
              ),
              textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
