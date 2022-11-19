import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../models/product.dart';
import '../screens/products_details_screen.dart';
class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProductDetailScreen(
                productId: product.id,
              );
            }));
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child('favorites')
                    .child(product.id)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Icon(snapshot.data!.snapshot.exists
                        ? Icons.favorite
                        : Icons.favorite_border);
                  }
                  return Container();
                }),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              FirebaseDatabase.instance
                  .ref()
                  .child('favorites')
                  .child(product.id)
                  .get()
                  .then((value) {
                if (value.exists) {
                  FirebaseDatabase.instance
                      .ref()
                      .child('favorites')
                      .child(product.id)
                      .remove();
                } else {
                  FirebaseDatabase.instance
                      .ref()
                      .child('favorites')
                      .child(product.id)
                      .set(true);
                }
              });
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              FirebaseDatabase.instance
                  .ref()
                  .child('cart')
                  .child(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(product.toJson());
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
