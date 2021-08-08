import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class userProductsScreen extends StatelessWidget {
  static const routName = '/user-Products';

  Future<void> refereshproduct(BuildContext context) async {
    final prod = await Provider.of<products>(context, listen: false)
        .fetchandsetproducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Your Products"),
          actions: [
            IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(editProductscreen.routName),
                icon: Icon(Icons.add)),
          ],
        ),
        body: FutureBuilder(
            future: refereshproduct(context),
            builder: (ctx, AsyncSnapshot snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => refereshproduct(context),
                        child: Consumer<products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, int index) => Column(
                                    children: [
                                      UserproductItem(
                                        id: productsData.items[index].id,
                                        title: productsData.items[index].title,
                                        imageUrl: productsData.items[index].imageUrl,
                                      ),
                                      Divider(height: 25,),
                                    ],
                                  )),
                            ),
                          ),
                        )));
  }
}
