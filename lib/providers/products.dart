import 'package:flutter/cupertino.dart';

import '../screens/models/product.dart';

class Products with ChangeNotifier {
  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'One Plus',
      description: 'best piece to use',
      price: 20000,
      imageUrl:
          'https://www.deccanherald.com/sites/dh/files/styles/article_detail/public/articleimages/2022/06/02/opnce-cov-sho-sel-1-1114681-1654183014.jpg?itok=g9QNvPbm',
    ),
    Product(
      id: 'p2',
      title: 'Sneaker',
      description: 'awesome to  daily use',
      price: 1200,
      imageUrl:
          'https://media.karousell.com/media/photos/products/2020/7/21/converse_chuck_taylor_mustard_1595374571_80fa8833_progressive.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Rolex Watch',
      description: 'Best for Personality',
      price: 4500,
      imageUrl:
          'https://www.watchshopping.com/media/tm_blog/p/o/1/8073/post_1_8073.jpg',
    ),
    Product(
      id: 'p4',
      title: 'shirts',
      description: 'Best to use',
      price: 450,
      imageUrl:
          'https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/11896080/2022/8/2/85763484-7792-449d-887c-9db0d14dcc111659416376505-Roadster-Men-Black-Regular-Fit-Solid-Sustainable-Casual-Shir-1.jpg',
    ),
  ];

  List<Product> get items {
    return [...loadedProducts];
  }

  Product findById(String id) {
    return loadedProducts.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
    id: DateTime.now().toString(),
    title: product.title,
    description: product.description,
    price: product.price,
    imageUrl: product.imageUrl,
    isFavorite: product.isFavorite);
    items.add(newProduct);

  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
    items[prodIndex] = newProduct;
    } else {
        print('...');
      }
    }

    void deleteProduct(String id) {
    items.removeWhere((prod) => prod.id == id);
  }

  void toggleFavorite(int index) {
    items.replaceRange(index, index + 1, [
      Product(
            id: items[index].id,
        title: items[index].title,
        description: items[index].description,
        price: items[index].price,
        imageUrl: items[index].imageUrl,
        isFavorite: !items[index].isFavorite)

        ]);
  }
}



























