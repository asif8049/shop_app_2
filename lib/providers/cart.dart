import 'package:flutter/foundation.dart';

import '../screens/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  //from Json
  CartItem.fromJson(Map<String, dynamic> json)
      : product = Product.fromJson(json['product']),
        quantity = json['quantity'];

  //to Json
  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  //copyWith
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Cart with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items {
    return _items;
  }

  double get totalAmount {
    var total = _items
        .map((e) => e.product.price)
        .toList()
        .reduce((value, element) => value + element);
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(
    String productid,
    double price,
    String title,
  ) {
    int indexWhere =
        _items.indexWhere((element) => element.product.id == productid);
    if (indexWhere != -1) {
      _items.replaceRange(indexWhere, indexWhere + 1, [
        CartItem(
          product: _items[indexWhere].product,
          quantity: _items[indexWhere].quantity + 1,
        )
      ]);
    } else {
      _items.add(
        CartItem(
          product: _items[indexWhere].product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    int indexWhere =
        _items.indexWhere((element) => element.product.id == productId);
    if (indexWhere != -1) {
      _items.removeAt(indexWhere);
      notifyListeners();
    }
  }

  void removeSingleItem(String productId) {
    if (!_items.any((element) => element.product.id == productId)) {
      return;
    }
    if (_items.isNotEmpty) {
      int indexWhere =
          _items.indexWhere((element) => element.product.id == productId);
      _items.replaceRange(indexWhere, indexWhere + 1, [
        CartItem(
          product: _items[indexWhere].product,
          quantity: _items[indexWhere].quantity - 1,
        )
      ]);
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
