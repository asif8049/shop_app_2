import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

//from json
  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = double.parse(json['amount'].toString()),
        products = (json['products'] as List)
            .map((e) => CartItem.fromJson(e))
            .toList(),
        dateTime = DateTime.parse(json['dateTime']);

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'products': products.map((e) => e.toJson()).toList(),
        'dateTime': dateTime.toIso8601String(),
      };
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    List<OrderItem> allOrders = [];
    for (var order in _orders) {
      allOrders.add(OrderItem(
          id: order.id,
          amount: order.amount,
          products: order.products,
          dateTime: order.dateTime));
    }
    return allOrders;
  }

  Future<void> fetchAndSetOrders() async {
    FirebaseDatabase.instance.ref().child("order").onValue.listen((event) {
      _orders.clear();
      _orders = event.snapshot.children
          .map((e) => OrderItem.fromJson(jsonDecode(jsonEncode(e.value))))
          .toList();
    });
    /*const url =
        'https://shop-flutter-42adb-default-rtdb.firebaseio.com/order.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['datetime']),
          products: (orderData['products'])
              .map(
                (item) => CartItem.fromJson(jsonDecode(item)),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();*/
  }

  /*Future<void> fetchAndSetOrders() async {
    const url =
        'https://shop-flutter-42adb-default-rtdb.firebaseio.com/order.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }*/

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        'https://shop-flutter-42adb-default-rtdb.firebaseio.com/order.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': DateTime.now().toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.product.id,
                  'title': cp.product.title,
                  'quantity': cp.quantity,
                  'price': cp.product.price,
                })
            .toList(),
      }),
    );

    _orders.add(
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: [...cartProducts],
      ),
    );
    notifyListeners();
  }
}
