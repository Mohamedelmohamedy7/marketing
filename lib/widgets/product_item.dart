import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_dart.dart';
import 'package:shop_app/providers/cart_dart.dart';
import 'package:shop_app/providers/cart_dart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool ontap=false;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart_prov = Provider.of<cart>(context, listen: false);
    final authdata = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed(productDetailScreen.routName,arguments: product.id),
          child: Hero(tag: product.id, child: FadeInImage(
            placeholder: AssetImage("assets/images/product-placeholder.png"),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          )),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center),
          leading: Consumer<Product>(
              builder: (ctx, pro, _) {
                return IconButton(
                  icon: Icon(product.isfavorite ? Icons.favorite : Icons
                      .favorite_border),
                  color: Theme
                      .of(context)
                      .accentColor,
                  onPressed: () {
                    product.toggleFaviratestatus(
                        authdata.token, authdata.userid);
                  },
                );
              }
          ),
          trailing: IconButton(
            color: Theme
                .of(context)
                .accentColor,
            onPressed: () {
              setState(() {
                ontap = !ontap;
              });
              cart_prov.additem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(content:Text("Product is Added"),
                  duration: Duration(seconds: 2),
              action:SnackBarAction(
                onPressed:(){
                  cart_prov.removeSingleItem(product.id);
                  setState(() {
                    ontap =false;
                  });
                },
                label: "Undo!",
              ) ,
              )
              );
            },
            icon: Icon(ontap==true?Icons.shopping_cart:Icons.shopping_cart_outlined),

          ),
        ),
      ),
    );
  }
}

