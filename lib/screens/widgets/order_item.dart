import 'dart:math';

import 'package:flutter/material.dart';

import '../../providers/orders.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  const OrderItemWidget(this.order);

  // const OrderItemWidget({Key? key, required this.order}) : super(key: key);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    widget.order.products.forEach((element) {
      print("quantity: ${element.quantity}");
    });
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? max(widget.order.products.length * 20.0 + 100, 10) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                //display date in dd//mm//yy format
                widget.order.dateTime.day.toString() +
                    '/' +
                    widget.order.dateTime.month.toString() +
                    '/' +
                    widget.order.dateTime.year.toString(),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 110, 200)
                  : 95,
              child: ListView(
                children: widget.order.products.map(
                  (cartItem) {
                    print("Product: ${cartItem.product.title}");
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          cartItem.product.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${cartItem.quantity}x \$${cartItem.product.price}',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
