import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items {
    return _items;
  }

  double get totalAmount {
    var total = _items
        .map((e) => e.price)
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
    int indexWhere = _items.indexWhere((element) => element.id == productid);
    if (indexWhere != -1) {
      _items.replaceRange(indexWhere, indexWhere + 1, [
        CartItem(
          id: _items[indexWhere].id,
          title: _items[indexWhere].title,
          price: _items[indexWhere].price,
          quantity: _items[indexWhere].quantity + 1,
        )
      ]);
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    int indexWhere = _items.indexWhere((element) => element.id == productId);
    if (indexWhere != -1) {
      _items.removeAt(indexWhere);
      notifyListeners();
    }
  }

  void removeSingleItem(String productId) {
    if (!_items.any((product) => product.id == productId)) {
      return;
    }
    if (_items.isNotEmpty) {
      int indexWhere = _items.indexWhere((element) => element.id == productId);
      _items.replaceRange(indexWhere, indexWhere + 1, [
        CartItem(
          id: _items[indexWhere].id,
          title: _items[indexWhere].title,
          price: _items[indexWhere].price,
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
