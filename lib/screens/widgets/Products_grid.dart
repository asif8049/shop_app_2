import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    List<Product> productsData = Provider.of<Products>(context).loadedProducts;
    List<Product> products = productsData;
    if (showFavs) {
      products.clear();
      for (var element in productsData) {
        if (element.isFavorite) {
          products.add(element);
        }
      }
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(product: products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
