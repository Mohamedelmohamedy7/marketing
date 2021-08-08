import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/providers/order_dart.dart' show Orderitem, order;
import 'package:shop_app/widgets/order_item.dart';

class orderScreen extends StatelessWidget {
  static const routName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<order>(context, listen: false).fetchandsetOrders(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text("An Error Occurred !"));
            } else {
          return Consumer<order>(
                builder: (ctx, orderdata, ch) {
                  return ListView.builder(
                      itemCount: orderdata.orders.length,
                      itemBuilder: (ctx, i) => ordersitemsnum(order_varaible:orderdata.orders[i]));
                },
              );
            }
          }
        },
      ),
    );
  }
}
