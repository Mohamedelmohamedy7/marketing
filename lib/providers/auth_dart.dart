import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_excption.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiretime;
  String _userid;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiretime != null &&
        _expiretime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }else {
      return null;
    }
  }

  String get userid {
    return _userid;
  }

  Future<void> _authinticate(String email, String password, String urlsegment) async {
    try {
      final res = await http.post(  //ابعت الملف دة كلة لل link دة
          Uri.parse(
              "https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key="
              "AIzaSyD9lM-0Fbn2YTF5-D2rQ-boQSFqPuTy4w0"),
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responsedata = json.decode(res.body);  //دة الرد ال هيجيلي وهعملة فك تشفير
      if (responsedata["error"] != null) {
       throw HttpException(responsedata["error"]["message"]); //لو الرد ال جالي فية error ابعتة لل HttpException
      }else {
        _token =
        responsedata["idToken"]; //ال _token بتاعى خلهولي ال response data ال جاي
        _userid = responsedata["localId"]; //ال _token بتاعى خلهولي ال response data ال جاي
        _expiretime = DateTime.now()
            .add(Duration(seconds: int.parse(
            responsedata["expiresIn"]))); // ال _token بتاعى خلهولي ال response data ال جاي

      }
      autologout();
      notifyListeners(); //لانى غيرت في ال _token و ال userid و ال _expiretime
      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': _userid,
        'expiresIn': _expiretime.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authinticate(email, password, "signUp");//دى بتيجي من الموقع ال هى ال signp
  } // for signup

  Future<void> login(String email, String password,) async {
    return _authinticate(email, password, "signInWithPassword");
  } //for log_in

  Future<bool> tryautolog() async {
    final prefs = await SharedPreferences.getInstance(); //هاخد object  من sharedprefernces
    if (!prefs.containsKey("userData")) return false; //معنديش داتا اصلا
    final Map<String, Object> extreacteddata =
        json.decode(prefs.getString("userData")) as Map<String, Object>; //طيب في عندى داتا رجعالي ع شكل map
    final expire = DateTime.parse(extreacteddata["expiresIn"]); //لانى محولة فوق
    if (expire.isBefore(DateTime.now())) return false; //شرط كدة جدعنة منى عشان لو ال expiretime بتاعة خلص
    _token = extreacteddata["token"]; //انت كنت فوق بتسكن الداتا هنا بترجع تساوي الداتا عشان ال log in auto
    _expiretime = expire;
    _userid = extreacteddata["userId"];
    notifyListeners(); //عشان جددت المخازن
    autologout();
    return true;
  } //for autologin
  Future<void>  logout() async {
    _token=null; _userid=null; _expiretime=null;
    if(_authTimer!=null)
      {_authTimer.cancel(); _authTimer=null; }
    notifyListeners();
    final prefs=await SharedPreferences.getInstance();
    prefs.clear();
  } //for log out
   void autologout() async{
    if(_authTimer!=null)
      {
        _authTimer.cancel();
      }
    int timertoexpriy;
    timertoexpriy=_expiretime.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds:timertoexpriy),logout);
}
}
