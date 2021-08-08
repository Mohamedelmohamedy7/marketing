import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import './providers/auth_dart.dart';
import './providers/cart_dart.dart';
import './providers/order_dart.dart';
import './providers/products.dart';

import './screens/auth_screen.dart';
import './screens/splach_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //عندى كذا provider
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: cart()),
        ChangeNotifierProxyProvider<Auth, products>(
            create: (_) => products(),
            update: (ctx, authvalue, previviousproduct) =>
            previviousproduct..getData(authvalue.token,
                authvalue.userid,previviousproduct==null?null: previviousproduct.items)
        ),
        ChangeNotifierProxyProvider<Auth, order>(
            create: (_) => order(),
            update: (ctx, authvalue, previviousorder) => previviousorder..getData(authvalue.token,
                authvalue.userid,previviousorder==null?null: previviousorder.orders)),      ],
      child: Consumer<Auth>(
        //استدعيت ال provider
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: "Lato"),
          home: auth.isAuth //هل في token هل في user مسجل اصلا وعندى قيم
              ? ProductOverviewScreen() //ادخل ال app
              : FutureBuilder(
                  //طيب لا يبقي روح سجل الاول
                  future: auth.tryautolog(),
                  builder: (ctx, AsyncSnapshot snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? splachScreen()
                          : Auth_screen(),
                ),
          debugShowCheckedModeBanner: false,
          routes: {
            productDetailScreen.routName: (_) => productDetailScreen(),
            cartScreen.routName: (_) => cartScreen(),
            editProductscreen.routName: (_) => editProductscreen(),
            orderScreen.routName: (_) => orderScreen(),
            userProductsScreen.routName: (_) => userProductsScreen(),
            splachScreen.routName: (_) => splachScreen(),
            UserproductItem.routName: (_) => UserproductItem(),

          },
        ),
      ),
    );
  }
}
