
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/models/http_excption.dart';
import 'package:shop_app/providers/cart_dart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/screens/user_products_screen.dart';

class products with ChangeNotifier {
  List<Product> _item = [
    // Product( id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',    // Product(
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),

  ];
  String authToken;
  String usedid;

  getData(String auth_Token, String uid, List<Product> products) {
    authToken = auth_Token;
    usedid = uid;
    _item = products;
    notifyListeners();
  }

  List<Product> get items {
    return [..._item];
  }

  List<Product> get favoriteitems {
    return _item.where((productitem) => productitem.isfavorite).toList();
  }

  Product findbyid(String id) {
    return _item.firstWhere((prodid) => prodid.id == id);
  }

  Future<void> fetchandsetproducts([bool filterbyuser = false]) async {
    final filterdString =
        filterbyuser ? 'orderBy="creatorId"&equalTo="$usedid"':'';
    var url = Uri.parse(
        "https://shop-46e8e-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterdString");
   // try {
 try{     final res = await http.get(url);
      final extracteddata = json.decode(res.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return;
      }
      url = Uri.parse(
          "https://shop-46e8e-default-rtdb.firebaseio.com/userFavorites/$usedid.json?auth=$authToken");
      final favres = await http.get(url);
      final extractfavdata = json.decode(favres.body);
      final List<Product> loadedproducts = [];
      extracteddata.forEach((prodid, proddata) {
        loadedproducts.add(
            Product(
          id: prodid,
          title: proddata["title"],
          description: proddata["description"],
          price: proddata["price"],
          imageUrl: proddata["imageUrl"],
          isfavorite: extractfavdata == null ? false : extractfavdata[prodid] ?? false,
        ));
      });
     _item = loadedproducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addproduct(Product product) async {
    try {
      var url = Uri.parse("https://shop-46e8e-default-rtdb.firebaseio.com/products.json?auth=$authToken");
      final res = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "creatorId": usedid,
          }));
      final newproduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _item .add(newproduct);
      notifyListeners();
    } catch (e) {
      throw e;
     }
  }
  Future<void> updateproduct(String id,Product newproduct) async {
    final prodindex=_item.indexWhere((prod) => prod.id==id);

    if(prodindex>=0)
      {
        print(prodindex);
        var url = Uri.parse("https://shop-46e8e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
        await http.patch(url,body: json.encode({
          "title": newproduct.title,
          "description": newproduct.description,
          "price": newproduct.price,
          "imageUrl": newproduct.imageUrl,
        }));
        _item[prodindex]=newproduct;
        notifyListeners();
      }else{
      print("___");
      print(prodindex);

    }

  }
  Future<void> deleteproduct(String id) async {
  final proddelete=_item.indexWhere((prod) => prod.id==id);
  var url = Uri.parse("https://shop-46e8e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
  var existproduct=_item[proddelete];
  _item.removeAt(proddelete);
  notifyListeners();
  final res= await http.delete(url);
  if(res.statusCode >=400)
    {
        _item.insert(proddelete, existproduct);
      notifyListeners();
      throw HttpException("Could not delete item");
    }
  existproduct=null;
    }
  }
