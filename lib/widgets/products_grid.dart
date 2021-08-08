import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showfaverite;

  ProductGrid(this.showfaverite);

  @override
  Widget build(BuildContext context) {
    final prouddata = Provider.of<products>(context);
    final productval = showfaverite ? prouddata.favoriteitems : prouddata.items;

    return productval.isEmpty
        ? Center(
            child: Text("There is No Product !",style: TextStyle(
              fontSize: 17
            ),),
          )
        : GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: productval.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: productval[i],
                  child: ProductItem(),
                ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
              crossAxisCount: 2,
            ));
  }
}
