import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_dart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';
import 'cart_screen.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _productOverviewScreenState createState() => _productOverviewScreenState();
}

enum FilterOption { Favorites, All }

class _productOverviewScreenState extends State<ProductOverviewScreen> {
  var _isloading = false;
  var _showOnlyfaveites = false;

  @override
  void initState() {
    super.initState();
    _isloading = true;
    Provider.of<products>(context, listen: false)
        .fetchandsetproducts()
        .then((_) {
      if (this.mounted) {
        setState(
          () => _isloading = false,
        );
      }
    }).catchError((_) {
      if (this.mounted) {
      setState(() {
        _isloading = false;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<products>(context)
        .fetchandsetproducts()
        .then((_) => _isloading = false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOption selected) {
                setState(() {
                  if (selected == FilterOption.Favorites) {
                    _showOnlyfaveites = true;
                  } else {
                    _showOnlyfaveites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text(
                          "only Favorites",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        value: FilterOption.Favorites),
                    PopupMenuItem(
                        child: Text("Show All",
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        value: FilterOption.All),
                  ]),
          Consumer<cart>(
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(cartScreen.routName),
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (_, cart, ch) =>
                Badge(value: cart.itemcount.toString(), child: ch),
          ),
        ],
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(_showOnlyfaveites),
      drawer: AppDrawer(),
    );
  }
}
