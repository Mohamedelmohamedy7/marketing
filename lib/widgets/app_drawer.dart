import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_dart.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text("Setting"),automaticallyImplyLeading: false,),
          ListTile(
            title:Text("Shop",style: TextStyle(fontWeight: FontWeight.bold),) ,
            leading:Icon(Icons.shop) ,
            onTap:()=>Navigator.of(context).pushReplacementNamed("/") ,
          ),
          Divider(thickness:1,),
          ListTile(
            title:Text("Orders",style: TextStyle(fontWeight: FontWeight.bold),) ,
            leading:Icon(Icons.payment) ,
            onTap:()=>Navigator.of(context).pushReplacementNamed(orderScreen.routName) ,
          ),
          Divider(thickness: 1,),
          ListTile(
            title:Text("Manage Products",style: TextStyle(fontWeight: FontWeight.bold),) ,
            leading:Icon(Icons.edit) ,
            onTap:()=>Navigator.of(context).pushReplacementNamed(userProductsScreen.routName) ,
          ),
          Divider(thickness: 1),
          ListTile(
            title:Text("Logout",style: TextStyle(fontWeight: FontWeight.bold),) ,
            leading:Icon(Icons.exit_to_app) ,
            onTap:(){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context,listen: false).logout();
            } ,
          ),
        ],
      ),
    );
  }
}
