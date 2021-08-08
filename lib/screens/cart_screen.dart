import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_dart.dart' show cart, cartItem;
import 'package:shop_app/providers/order_dart.dart';
import 'package:shop_app/widgets/cart_item.dart';

class cartScreen extends StatelessWidget {
  static const routName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartval = Provider.of<cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontSize: 25),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    "${cartval.itemAmount.toStringAsFixed(2)}\$",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                OrderButton(
                  cart_val: cartval,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
              itemCount: cartval.item.length,
              itemBuilder: (ctx, index) => CartItem(
                    id: cartval.item.values.toList()[index].id,
                    prouductId: cartval.item.keys.toList()[index],
                    title: cartval.item.values.toList()[index].title,
                    quntity: cartval.item.values.toList()[index].quntity,
                    price: cartval.item.values.toList()[index].price,
                  )),
        )
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cart cart_val;

  OrderButton({@required this.cart_val});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart_val.itemAmount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<order>(context, listen: false).addOrder(
                widget.cart_val.item.values.toList(),
                widget.cart_val.itemAmount,
              );
              setState(() {
                _isloading = false;
              });
              widget.cart_val.clear();
            },
      child: _isloading
          ? CircularProgressIndicator()
          : Text(
              "OrderNow",
              style: TextStyle(fontSize: 15),
            ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
