import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/screens/edit_product_screen.dart';

import '../../providers/products.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const EditProductScreen();
              }));
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance.refFromURL("https://shop-flutter-42adb-default-rtdb.firebaseio.com/").child('products').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Product> products = snapshot.data!.snapshot.children
                    .map((e) =>
                        Product.fromJson(jsonDecode(jsonEncode(e.value))))
                    .toList();

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, i) => Column(
                    children: [
                      UserProductItem(
                        product: products[i],
                        onProductDeleted: () {
                          print("On Delete Pressed");
                          Provider.of<Products>(context, listen: false)
                              .deleteProduct(products[i].id);
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }
}
