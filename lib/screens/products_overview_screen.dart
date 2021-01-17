

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
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .fetchProducts();
        await Provider.of<Cart>(context, listen: false).fetchCartItems();

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        print(error);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Oops!!!'),
                content: Text('Cannot get items....'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Okay'))
                ],
              );
            });
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        backgroundColor: Colors.transparent,
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
            builder: (context, cart, child) => Badge(
                color: Colors.redAccent,
                child: child,
                value: cart.getItemCount.toString()),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<ProductsProvider>(context, listen: false)
                    .fetchProducts();
                Provider.of<Cart>(context, listen: false).fetchCartItems();
              },
              child: ProductsGrid(
                showOnlyFavourites: _showOnlyFavourite,
              ),
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
        shrinkWrap: true,
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
