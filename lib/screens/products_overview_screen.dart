import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions option) {
                setState(() {
                  if (option == FilterOptions.Favourites) {
                    _showOnlyFavourite = true;
                  } else {
                    _showOnlyFavourite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourite'),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    )
                  ]),
          Consumer<Cart>(
              builder: (context, cart, child) =>
                  Badge(
                      color: Colors.redAccent,
                      child: child,
                      value: cart.getItemCount.toString()),

          child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
            Navigator.pushNamed(context, CartScreen.routeName);

          }),
          ),


        ],

      ),
      drawer: AppDrawer(),
      body: ProductsGrid(
        showOnlyFavourites: _showOnlyFavourite,
      ),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavourites;

  ProductsGrid({this.showOnlyFavourites});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    List<Product> products = showOnlyFavourites
        ? productData.showOnlyFavourites()
        : productData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          // used Provider because we need to trigger isFavourite function in Product() but in other screens we don't need to do that
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
          );
        });
  }
}
