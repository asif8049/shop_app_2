import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/screens/edit_product_screen.dart';

import '../../providers/products.dart';
import '../models/product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EditProductScreen(
                    product: product,
                  );
                }));
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
