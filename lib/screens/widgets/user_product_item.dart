import 'package:flutter/material.dart';
import 'package:shop_app/screens/screens/edit_product_screen.dart';

import '../models/product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  final Function() onProductDeleted;

  const UserProductItem(
      {Key? key, required this.product, required this.onProductDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
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
              icon: const Icon(Icons.delete),
              onPressed: () {
                onProductDeleted();
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
