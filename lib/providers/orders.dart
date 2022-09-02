import 'package:flutter/foundation.dart';

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
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    List<OrderItem> allOrders = [];
    _orders.forEach((order) {
      allOrders.add(OrderItem(
          id: order.id,
          amount: order.amount,
          products: order.products,
          dateTime: order.dateTime));
    });
    return allOrders;
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.add(
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: [...cartProducts],
      ),
    );
    notifyListeners();
  }
}
