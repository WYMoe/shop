import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';

class ProductManageScreen extends StatelessWidget {
  static const routeName = '/product_manage_screen';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyProducts'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await products.fetchProducts();
          } catch (error) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Oops!!!'),
                    content: Text('There was an error....'),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Okay'))
                    ],
                  );
                });
          }
        },
        child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (context, index) {
              return ProductWidget(
                  id: products.items[index].id,
                  title: products.items[index].title,
                  url: products.items[index].imageUrl);
            }),
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final String id;
  final String url;
  final String title;

  ProductWidget({this.id, this.url, this.title});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(url)),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text('Do you want to delete this product?'),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No')),
                            FlatButton(
                                onPressed: () async {
                                  try {
                                    await Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .deleteProduct(id);
                                    Navigator.pop(context);
                                  } catch (error) {
                                    scaffold.showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          'Deleting failed!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Yes')),
                          ],
                        );
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
