import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/widgets/cart_items.dart';

class CartScreen extends StatefulWidget {


  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CartItem> cart = Provider.of<Cart>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cart.isNotEmpty
                          ? cart
                              .map((e) => e.product.price)
                              .toList()
                              .reduce((value, element) => value + element)
                              .toString()
                          : '0.0',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline1!
                            .color!,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart,
                        cart
                            .map((e) => e.product.price)
                            .toList()
                            .reduce((value, element) => value + element),
                      );
                      for (int i = 0; i < cart.length; i++) {
                        Provider.of<Cart>(context, listen: false)
                            .removeItem(cart[i].product.id);
                        i--;
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (ctx, i) => CartItems(
                cart[i].product,
                cart[i].quantity,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
