import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('loadedProduct.title')),
      body: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child('products')
              .child(productId)
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Product loadedProduct = Product.fromJson(
                  jsonDecode(jsonEncode(snapshot.data!.snapshot.value)));
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${loadedProduct.price}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Text(
                        loadedProduct.description,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }
}
