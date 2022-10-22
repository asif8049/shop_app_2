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
                  OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final List<CartItem> cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading
          ? Container(
              child: CircularProgressIndicator(),
            )
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      onPressed: (widget.cart
                      .map((e) => e.product.price)
                      .toList()
                      .reduce((value, element) => value + element) <=
                  0 ||
              _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart,
                widget.cart
                    .map((e) => e.product.price)
                    .toList()
                    .reduce((value, element) => value + element),
              );
              setState(() {
                _isLoading = false;
              });
              for (int i = 0; i < widget.cart.length; i++) {
                Provider.of<Cart>(context, listen: false)
                    .removeItem(widget.cart[i].product.id);
                i--;
              }
            }),
    );
  }
}
