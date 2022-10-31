import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/models/product.dart';
import 'package:shop_app/screens/widgets/cart_items.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CartItem> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: StreamBuilder<DatabaseEvent>(
                        stream: FirebaseDatabase.instance
                            .ref()
                            .child('cart')
                            .onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Product> products = snapshot
                                .data!.snapshot.children
                                .map((e) => Product.fromJson(
                                    jsonDecode(jsonEncode(e.value))))
                                .toList();

                            for (var product in products) {
                              if (cart.any((element) =>
                                  element.product.id == product.id)) {
                                cart
                                    .firstWhere((element) =>
                                        element.product.id == product.id)
                                    .copyWith(
                                        quantity: cart
                                                .firstWhere((element) =>
                                                    element.product.id ==
                                                    product.id)
                                                .quantity +
                                            1);
                              } else {
                                cart.add(
                                    CartItem(product: product, quantity: 1));
                              }
                            }
                            return StreamBuilder<DatabaseEvent>(
                                stream: FirebaseDatabase.instance
                                    .ref()
                                    .child('cart')
                                    .onValue,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<Product> products = snapshot
                                        .data!.snapshot.children
                                        .map((e) => Product.fromJson(
                                            jsonDecode(jsonEncode(e.value))))
                                        .toList();
                                    return Text(
                                      products.isNotEmpty
                                          ? products
                                              .map((e) => e.price)
                                              .toList()
                                              .reduce((value, element) =>
                                                  value + element)
                                              .toString()
                                          : '0',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .headline1!
                                            .color!,
                                      ),
                                    );
                                  }
                                  return Container();
                                });
                          }
                          return Container();
                        }),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref().child('cart').onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> products = snapshot.data!.snapshot.children
                        .map((e) =>
                            Product.fromJson(jsonDecode(jsonEncode(e.value))))
                        .toList();
                    List<CartItem> cart = [];
                    for (var product in products) {
                      if (cart
                          .any((element) => element.product.id == product.id)) {
                        int indexWhere = cart.indexWhere(
                            (element) => element.product.id == product.id);
                        int quantity = cart[indexWhere].quantity;

                        cart.replaceRange(indexWhere, indexWhere + 1, [
                          cart[indexWhere].copyWith(quantity: quantity + 1)
                        ]);
                      } else {
                        cart.add(CartItem(product: product, quantity: 1));
                      }

                      print(cart[0].quantity);
                    }
                    return ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (ctx, i) => CartItems(
                        cart[i].product,
                        cart[i].quantity,
                      ),
                    );
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final List<CartItem> cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: _isLoading
            ? Container(
                child: const CircularProgressIndicator(),
              )
            : Text(
                'ORDER NOW',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
        onPressed: () async {
          FirebaseDatabase.instance.ref().child('cart').get().then((value) {
            List<Product> products = value.children
                .map((e) => Product.fromJson(jsonDecode(jsonEncode(e.value))))
                .toList();
            List<CartItem> cart = [];
            for (var product in products) {
              if (cart.any((element) => element.product.id == product.id)) {
                int indexWhere = cart
                    .indexWhere((element) => element.product.id == product.id);

                int quantity = cart[indexWhere].quantity;

                cart.replaceRange(indexWhere, indexWhere + 1,
                    [cart[indexWhere].copyWith(quantity: quantity + 1)]);
              } else {
                cart.add(CartItem(product: product, quantity: 1));
              }
            }
            OrderItem orderItem = OrderItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: products.isNotEmpty
                    ? products
                        .map((e) => e.price)
                        .toList()
                        .reduce((value, element) => value + element)
                    : 0,
                products: cart,
                dateTime: DateTime.now());
            FirebaseDatabase.instance
                .ref()
                .child('orders')
                .child(orderItem.id)
                .set(orderItem.toJson())
                .then((value) {
              FirebaseDatabase.instance.ref().child('cart').remove();
            });
          });
        });
  }
}
