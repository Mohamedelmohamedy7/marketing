import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_excption.dart';
import 'package:shop_app/providers/auth_dart.dart';

class Auth_screen extends StatefulWidget {
  static const routName = '/Auth';

  @override
  _Auth_screenState createState() => _Auth_screenState();
}

class _Auth_screenState extends State<Auth_screen> {
  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //     colors: [
        //       Color.fromRGBO(167, 162, 162, 1.0).withOpacity(0.5),
        //       Color.fromRGBO(113, 0, 0, 1.0).withOpacity(0.9),
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   )),
        // ),
        Container(
          height: devicesize.height,
          width: devicesize.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/back.jpg"), fit: BoxFit.cover),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: devicesize.height,
            width: devicesize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Flexible(
                  child: Authcard(),
                  flex: devicesize.width > 600 ? 2 : 1,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Authcard extends StatefulWidget {
  @override
  _AuthcardState createState() => _AuthcardState();
}

enum Authmode { Log_in, Sign_up }

class _AuthcardState extends State<Authcard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey();

  Authmode _authmode = Authmode.Log_in;

  Map<String, String> _authData = {"email": "", "password": ""};
  bool _isloading = false;
  final passwordcontroller = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slide_animation;
  Animation<double> _opacityanimation;
  bool abscureval = true;
  bool valemail=false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slide_animation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _opacityanimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  } //for intalize controller

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  } //for distroy the page of animation

  Future<void> _submit() async {
    if (!_formkey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus(); //عشان ااخلي ال كيبورد يقفل لوحدة
    _formkey.currentState.save(); //seve للقيم ال داخلة عندى
    setState(() {
      _isloading = true;
    });
    try {
      if (_authmode == Authmode.Log_in) {
        //لو المود login دخلي ال password
        await Provider.of<Auth>(context, listen: false)
            .login(_authData["email"], _authData["password"]);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData["email"], _authData["password"]);
      }
    } on HttpException catch (error) {
      var error_message = "Authentication failed";
      if (error.toString().contains("EMAIL_EXISTS"))
        error_message = "Invalid Email";
      else if (error.toString().contains("INVALID_EMAIL"))
        error_message = "this Eamil is not valid";
      else if (error.toString().contains("WEAK_PASSWORD"))
        error_message = "this password is weak";
      else if (error.toString().contains("EMAIL_NOT_FOUND"))
        error_message = "could not found user with this email";
      else if (error.toString().contains("INVALID_PASSWORD")) {
        error_message = "password is invalid";
      }
      _showErrordialog(error_message);
    } catch (error) {
      const error_message = "could not authenticate you ,try again later";
      _showErrordialog(error_message);
    }
  }

  void _showErrordialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("An Error Occurred"),
            content: Text(message),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("okey !"))
            ],
          );
        });
    setState(() {
      _isloading = false;
    });
  }

  void switchauthmode() {
    if (_authmode == Authmode.Log_in) {
      setState(() {
        _authmode = Authmode.Sign_up; // خليها 1=
      });
      _controller.forward();
    } else {
      setState(() {
        _authmode = Authmode.Log_in;
      });
      _controller.reverse();
    }

    setState(() {
      _isloading = false;
    });
  } //method for login or signup

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: Authmode == Authmode.Sign_up ? 450 : 400,
        constraints:
            BoxConstraints(minHeight: Authmode == Authmode.Sign_up ? 320 : 300),
        width: devicesize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "${_authmode == Authmode.Log_in ? 'SIGN IN' : 'SIGN UP'}",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    fillColor: Colors.purple,
                    filled: true,
                    // labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Enter Your E-mail",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 13),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val.isEmpty ) {
                      return "Email is required";
                    } else if (!val.contains("@")){
                      return "invalid Email";
                    }
                    else {
                        valemail=true;
                      return null;
                    }
                  },
                  onSaved: (value) => _authData["email"] = value,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        abscureval ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          abscureval = !abscureval;

                        });
                      },
                    ),
                    fillColor: Colors.purple,
                    filled: true,
                    //    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 13),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  controller: passwordcontroller,
                  validator: (val) {
                    if (val.isEmpty) {
                      return " password is required";
                    }else if  (val.length < 5) {
                      return " password is Too short";
                    }else if ( valemail==false)
                      {
                        return "Email required";
                      }
                    else
                      {
                        return null;
                      }
                  },
                  obscureText: abscureval,
                  onSaved: (value) => _authData["password"] = value,
                ),
                SizedBox(
                  height: 30,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authmode == Authmode.Sign_up ? 60 : 0,
                    maxHeight: _authmode == Authmode.Sign_up ? 120 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityanimation,
                    child: SlideTransition(
                      position: _slide_animation,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              abscureval ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                abscureval = !abscureval;
                              });
                            },
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 20,
                          ),
                          fillColor: Colors.purple,
                          filled: true,
                          //  labelText: "conform Password",
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: "conform Your Password",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 13),
                          enabled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        enabled: _authmode == Authmode.Sign_up,
                        obscureText: abscureval,
                        validator: _authmode == Authmode.Sign_up
                            ? (val) {
                                if (val != passwordcontroller.text) {
                                  return "password is not match";
                                } else {
                                  return null;
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                if (_isloading) CircularProgressIndicator(),
                SizedBox(height: 1),
                RaisedButton(
                  onPressed: _submit,
                  child: Text(
                    _authmode == Authmode.Log_in ? "Login" : "SignUp",
                    style: TextStyle(),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  textColor: Theme.of(context).primaryTextTheme.headline6.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: 9,
                ),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  child: Text(
                    'Do you want to ${_authmode == Authmode.Log_in ? 'Singup' : 'Login'} Instead ? ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onPressed: switchauthmode,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 4),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
