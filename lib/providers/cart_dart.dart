import 'package:flutter/material.dart';

class cartItem {
  final String id;
  final String title;
  final int quntity;
  final double price;

  cartItem({
    @required this.id,
    @required this.title,
    @required this.quntity,
    @required this.price,
  });

 }

class cart with ChangeNotifier {
  Map<String, cartItem> _item = {}; //المكان ال هحفظ فية الحاجات ال هشتريها

  Map<String, cartItem> get item {
    return {..._item};  //عشان اتعامل مع الليست من برة ال كلاس
  }

  int get itemcount { //ترجعلي طول اللست
    return _item.length;
  }

  double get itemAmount { //احسبلي فلوس الحاجة ال اشترتها كلها
    var total = 0.0;
    _item.forEach((key, cartItem) {  //لازم يكون م نوع ال ال كلاااس
      total =total+ (cartItem.price * cartItem.quntity);  //ممكن اشتري اكتر من الواحدة ف النوع الواحد
    });
    return total;
  }

  void additem(String prouductid, double price, String title) {
    if (_item.containsKey(prouductid)) { //جددلي علية وزودلي الكمية واحد يعنى اشتريت المنتج مرة وهشترية تانى
      _item.update(prouductid, (existingidcard) =>
          cartItem(
            id: existingidcard.id,
            title: existingidcard.title,
            quntity: existingidcard.quntity + 1,
            price: existingidcard.price,
          ));

    } else {
      _item.putIfAbsent( //اول مرة اشترية خلالي الكمية 1
          prouductid,
              () =>
              cartItem(
                id: DateTime.now().toString(), //التاريخ ال اشتريت فية المنتج
                title: title,
                quntity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeItem(String proudictId) {
    _item.remove(proudictId); //امسح منتج ع طول
    notifyListeners();
  }

  void removeSingleItem(String proudId) {
    if (!_item.containsKey(proudId)) return; //لو مش موجود عندى همسحة ازاي اصلا
    if (_item[proudId].quntity > 1) {
      _item.update(proudId, (existingCardItem) {
      return cartItem(id: existingCardItem.id, title: existingCardItem.title,
          quntity: existingCardItem.quntity -1, price: existingCardItem.price,);
      });
    } else{
      _item.remove(proudId); //مهنديش غير كمية 1 فامسحها واخلص
    }
    notifyListeners();
  }

  void clear() {
    _item = {}; //امسحلي كل حاجة وتقريبا كانت تنقع بردة _item.clear();
    notifyListeners();
  }
}
