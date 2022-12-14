import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../screens/models/product.dart';

class Products with ChangeNotifier {
  List<Product> loadedProducts = [
    // Product(
    //  id: 'p1',
    //title: 'One Plus',
    //  description: 'best piece to use',
    // price: 20000,
    // imageUrl:
    //   'https://images.fonearena.com/blog/wp-content/uploads/2021/05/OnePlus-9R_FoneArena-1-1024x638.jpg',
    // ),
    //Product(
    //  id: 'p2',
    // title: 'Sneaker',
    //description: 'awesome to  daily use',
    // price: 1200,
    //imageUrl:
    //      'https://media.karousell.com/media/photos/products/2020/7/21/converse_chuck_taylor_mustard_1595374571_80fa8833_progressive.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //  title: 'Rolex Watch',
    //  description: 'Best for Personality',
    //  price: 4500,
    //   imageUrl:
    //      'https://content.rolex.com/dam/2022/upright-bba-with-shadow/m278288rbr-0038.png?impolicy=v6-upright&imwidth=270',
    //  ),
    //   Product(
    //   id: 'p4',
    //   title: 'shirts',
    //  description: 'Best to use',
    //  price: 450,
    //   imageUrl:
    //       'https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/11896080/2022/8/2/85763484-7792-449d-887c-9db0d14dcc111659416376505-Roadster-Men-Black-Regular-Fit-Solid-Sustainable-Casual-Shir-1.jpg',
    //  ),
    // Product(
    //      id: 'p5',
    //      title: 'Perfume',
    //      description: 'Best perfume to use',
    //      price: 700,
    //    imageUrl:
    //          'https://oudandmusk.com/2405-large_default/fakhar-al-oud-perfume.jpg'),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    // return loadedProducts.where((prodItem) => prodItem.isFavorites).toList();
    //}
    return [...loadedProducts];
  }

  List<Product> get favoritesItems {
    return loadedProducts.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return loadedProducts.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly {
// _showFavoritesOnly True;
// notifyListeners();
// }

  // void showAll() {
  // _showFavoritesOnly = false;
  // notifyListeners();
// }

  Future<void> addProduct(Product product) async {
    print("Add product called");
    await FirebaseDatabase.instance
        .refFromURL ("https://shop-flutter-42adb-default-rtdb.firebaseio.com/products.json?authToken")
        .child('products')
        .child(product.id)
        .set(product.toJson())
        .then((value) {
      print("Product added successfully");
    });
    /*String url =
        'https://shop-flutter-42adb-default-rtdb.firebaseio.com/products/${product.id}.json';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    );
    Map<String, dynamic> extractedData = jsonDecode(response.body);
    if (extractedData == null) {
      return;
    }

    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        isFavorite: prodData['isFavorite'],
        imageUrl: prodData['imageUrl'],
      ));
    });
    notifyListeners();

    // print(json.decode(response.body));
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: json.decode(response.body)['name'],
    );
    loadedProducts.add(newProduct);
    // loadedProducts.insert(0, newProduct); at the start of the list

    notifyListeners();*/
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    await FirebaseDatabase.instance
        .ref()
        .child('products')
        .child(id)
        .set(newProduct.toJson());
    /*final prodIndex = loadedProducts.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-flutter-42adb-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      loadedProducts[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }*/
  }

  Future<void> deleteProduct(String id) async {

    print("Product ID: $id");

   /* http.delete(Uri.parse(url)).then((response) {
      int productIndex = loadedProducts.indexWhere((prod) => prod.id == id);
      print("Product Index: $productIndex");
      loadedProducts.removeWhere((prod) => prod.id == id);
      fetchAndSetProducts();
    });*/

    await FirebaseDatabase.instance
        .refFromURL("https://shop-flutter-42adb-default-rtdb.firebaseio.com/")
        .child('products')
        .child(id)
        .remove();
  }
}
