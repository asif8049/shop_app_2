import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

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
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return OrdersScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('My Shop'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return UserProductsScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
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
