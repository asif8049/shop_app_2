import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/screens/cart_screen.dart';
import 'package:shop_app/screens/widgets/Products_grid.dart';
import 'package:shop_app/screens/widgets/app_drawer.dart';

import '../models/product.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  final _isInit = true;
  final _isLoading = false;

  @override
  void initState() {
    //   Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  child: Text('Show All'), value: FilterOptions.All),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              print("Cart Pressed");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CartScreen();
              }));
            },
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
                  child: Icon(Icons.shopping_cart),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: StreamBuilder<DatabaseEvent>(
                        stream: FirebaseDatabase.instance
                            .ref()
                            .child('products')
                            .onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Product> products = snapshot
                                .data!.snapshot.children
                                .map((e) => Product.fromJson(
                                    jsonDecode(jsonEncode(e.value))))
                                .toList();
                            products.toSet().toList();
                            return Text(
                              products.length.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            );
                          }
                          return Container();
                        }),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
