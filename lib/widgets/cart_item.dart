import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_dart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prouductId;
  final String title;
  final int quntity;
  final double price;

  const CartItem({
    @required this.id,
    @required this.prouductId,
    @required this.title,
    @required this.quntity,
    @required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 25,
          ),
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          padding: EdgeInsets.only(right: 20),
          color: Theme.of(context).errorColor,
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Are you sure ? "),
                 elevation: 5,
                 content: Text("Do you want remove this product from your cart ?"),
                actions: [
                  FlatButton(
                    onPressed: ()=>Navigator.of(context).pop(),
                    child: Text("No"),
                  ),
                  FlatButton(
                    onPressed: ()=>Navigator.of(context).pop(true),
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction){
          Provider.of<cart>(context,listen: false).removeItem(prouductId);

        },
        key: ValueKey(id),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: ListTile(
              title: Text(title),
              subtitle: Text("${price * quntity}\$"),
              trailing: Text("$quntity x"),
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: FittedBox(
                    child: Text(
                      "$price \$",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
