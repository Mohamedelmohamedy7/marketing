import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserproductItem extends StatelessWidget {
  static const routName = '/User-product';
  final String id;
  final String title;
  final String imageUrl;

  const UserproductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
    leading: CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
    ),
    trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(editProductscreen.routName,arguments: id),
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async{
                  try {
                    await Provider.of<products>(context,listen: false).deleteproduct(id);
                  } catch (e) {
                    scaffold.showSnackBar(SnackBar(
                      content: Text("delete item is failed,Check the internet"),
                        duration:Duration(seconds: 2),
                    ));
                   }
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),

    ));
  }
}
