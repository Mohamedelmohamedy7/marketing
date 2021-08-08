import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavorite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isfavorite = false,
  });

  void _setfavvalue(bool newval) {
    isfavorite = newval;
    notifyListeners();
  }

  Future<void> toggleFaviratestatus(String token, String userid) async{
    final oldstatus=isfavorite;
    isfavorite = !isfavorite;
    print(userid);
    notifyListeners();

  try {
    final res = await http.put(Uri.parse("https://shop-46e8e-default-rtdb.firebaseio.com/userFavorites/$userid/$id.json?auth=$token"
    ),
        body:json.encode(isfavorite));
    if(res.statusCode>=400)
      {
        _setfavvalue(oldstatus);
      }
  } catch (e) {
    _setfavvalue(oldstatus);
  }
  }
}

