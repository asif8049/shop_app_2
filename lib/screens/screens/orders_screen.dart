import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/widgets/order_item.dart';

import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {




/*  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref().child("order").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderItem> orderData = snapshot.data!.snapshot.children
                  .map((e) =>
                  OrderItem.fromJson(jsonDecode(jsonEncode(e.value))))
                  .toList();
              return ListView.builder(
                itemCount: orderData.length,
                itemBuilder: (ctx, i) => OrderItemWidget(orderData[i]),
              );
            }
            return Container();
          }),
    );
  }
}
