import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Pathaan',
        description: 'Pathaan sunglass is awesome!',
        price: 29.199,
        imageUrl: 'https://static.toiimg.com/photo/90475021/90475021.jpg?v=3'),
    Product(
        id: 'p2',
        title: 'Paji',
        description: 'A nice pair of trouser.',
        price: 59.099,
        imageUrl:
            'https://c.ndtvimg.com/2021-09/cejn9c1o_arshdeep-singh-instagram_625x300_21_September_21.jpg'),
    Product(
        id: 'p3',
        title: 'Kings',
        description: 'The best flag of kings',
        price: 19.999,
        imageUrl:
            'https://i.cdn.newsbytesapp.com/images/l23620220212170928.jpeg'),
    Product(
        id: 'p4',
        title: 'Yuvi',
        description: 'The Bat of worldcup semi-final of yuvi',
        price: 49.999,
        imageUrl:
            'https://static.india.com/wp-content/uploads/2021/10/Yuvraj-Singh.jpg'),
    Product(
        id: 'p5',
        title: 'Mobile',
        description: 'The one plus mobile',
        price: 19.999,
        imageUrl:
            'https://www.deccanherald.com/sites/dh/files/styles/article_detail/public/articleimages/2022/06/02/opnce-cov-sho-sel-1-1114681-1654183014.jpg'),
  ];

  var showFavoritesOnly = false;

  List<Product> get items {
    //  if (showFavoritesOnly) {
    //    return _items.where((prodItem) => prodItem.isFavorite).toList();
    //  }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

//  void showFavoritesOnly() {
//    _showFavoritesOnly = true;
  //   notifyListeners();
//  }

//  void showAll() {
//    _showFavoritesOnly = false;
//    notifyListeners();
//  }

  void addProduction(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void addProduct(Product editedProduct) {
    _items.add(editedProduct);
    notifyListeners();
  }
  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id ==id);
    notifyListeners();
  }
}
