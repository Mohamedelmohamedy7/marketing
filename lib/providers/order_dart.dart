import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/providers/products.dart';

class Orderitem {
  final String id;
  final double amount;
  final List<cartItem> products;
  final DateTime dateTime;

  Orderitem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class order with ChangeNotifier {
  List<Orderitem> _orders = [];
  String authToken;
  String usedid;

  getData(String auth_Token, String uid, List<Orderitem> orders) {
    authToken = auth_Token;
    usedid = uid;
    _orders = orders;
    notifyListeners();
  }

  List<Orderitem> get orders {
    return [..._orders];
  }

  Future<void> fetchandsetOrders() async {
    final url = Uri.parse(
        "https://shop-46e8e-default-rtdb.firebaseio.com/orders/$usedid.json?auth=$authToken");
    try {
      final res = await http.get(url);
      final extracteddata = json.decode(res.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return;
      }
      final List<Orderitem> loadedorder = [];
      extracteddata.forEach((orderid, orderdata) {
        loadedorder.add(Orderitem(
          id: orderid,
          amount: orderdata["amount"],
          dateTime: DateTime.parse(orderdata["dateTime"]),
          products: (orderdata["products"] as List<dynamic>).map((item) =>
              cartItem(
                id: item['id'],
                price: item['price'],
                title: item['title'],
                quntity: item['quntity'],))
              .toList(),
        ));
      });
      _orders = loadedorder.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<cartItem> cartproduct, double total) async {
    try {
      var url = Uri.parse(
          "https://shop-46e8e-default-rtdb.firebaseio.com/orders/$usedid.json?auth=$authToken");
      final timestamp = DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            "amount": total,
            "dateTime": timestamp.toIso8601String(),
            "products": cartproduct.map((item) =>
            ({
              "id": item.id,
              "title": item.title,
              "price": item.price,
              "quntity": item.quntity
            })).toList(),

          }));
      ///////////////////////////////كل دة داتاا بيز
      //من اول هنا بقا برنامج
      _orders.insert(0, Orderitem(
        id: json.decode(res.body)['name'],
        amount: total,
        products: cartproduct,
        dateTime: timestamp,));
      notifyListeners();
    }catch(e){
      throw e;
    }
  }
}