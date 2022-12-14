import 'package:flutter/material.dart';
import 'package:shop_app/screens/screens/products_overview_screen.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const OrdersScreen();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('My Shop'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProductsOverviewScreen();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Product'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return UserProductsScreen();
              }));
            },
          )
        ],
      ),
    );
  }
}
