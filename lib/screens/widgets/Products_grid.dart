import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    List<Product> productsData = Provider.of<Products>(context).loadedProducts;
    List<Product> products = productsData;
    if (showFavs) {
      products.clear();
      productsData.forEach((element) {
        if (element.isFavorite) {
          products.add(element);
        }
      });
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(product: products[i]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
