import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order_dart.dart' as ord;

class ordersitemsnum extends StatelessWidget {
  final ord.Orderitem order_varaible;

  const ordersitemsnum({this.order_varaible});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
        iconColor: Theme.of(context).primaryColor,
        textColor: Colors.black,
        title: Text("\$${order_varaible.amount} "),
        subtitle: Text(
            DateFormat('dd/MM/yyyy    hh:mm').format(order_varaible.dateTime)),
        children: order_varaible.products
            .map((proud) => Padding(
              padding: const EdgeInsets.only(left: 20,right: 15),
              child: Column(
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          proud.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.purple),
                        ),
                        Text(
                          '${proud.quntity} x \$ ${proud.price}',
                          style:
                              TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
          ],
              ),
            ))
            .toList(),
      ),
    );
  }
}
