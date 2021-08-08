import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class editProductscreen extends StatefulWidget {
  static const routName = '/edit-Product';

  @override
  _editProductscreenState createState() => _editProductscreenState();
}

class _editProductscreenState extends State<editProductscreen> {
  final _pricefocusNodes = FocusNode();
  final _descriptionfocusNodes = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlfocusNodes = FocusNode();
  final _formkey = GlobalKey<FormState>();
  var _editeddata = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );
  var _initialValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };
  var _isloading = false;
  var _isinit = true;

  @override
  void initState() {
    super.initState();
    _imageUrlfocusNodes.addListener(_updateimageurl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isinit) {
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        _editeddata = Provider.of<products>(context,listen: false).findbyid(productid);
        _initialValues = {
          "title": _editeddata.title,
          "description": _editeddata.description,
          "price": _editeddata.price.toString(),
          "imageUrl": "",
        };
        _imageUrlController.text = _editeddata.imageUrl;
      }
      _isinit = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlfocusNodes.removeListener(_updateimageurl);
    _pricefocusNodes.dispose();
    _imageUrlfocusNodes.dispose();
    _imageUrlController.dispose();
    _descriptionfocusNodes.dispose();
  }

  void _updateimageurl() {
    if (!_imageUrlfocusNodes.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isvalid = _formkey.currentState.validate();
    if (!isvalid) {return;}
      _formkey.currentState.save();
      setState(() {
        _isloading = true;
      });
      if (_editeddata.id != null) {
        await Provider.of<products>(context, listen: false)
            .updateproduct(_editeddata.id, _editeddata);
      } else {
        try {
          await Provider.of<products>(context, listen: false)
              .addproduct(_editeddata);
        } catch (e) {
          await showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  content: Text("Something want wrong"),
                  title: Text("An Error Occurred"),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text("Okey"),
                    )
                  ],
                );
              });
        }

      } setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop() ;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isloading
          ? Center(
              child:CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValues['title'],
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocusNodes);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please provide a value";
                        }
                          return null;

                      },
                      onSaved: (value) {
                        _editeddata = Product(
                          imageUrl: _editeddata.imageUrl,
                          description: _editeddata.description,
                          title: value,
                          price: _editeddata.price,
                          id: _editeddata.id,
                          isfavorite: _editeddata.isfavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['price'],
                      decoration: InputDecoration(
                        labelText: "Price",
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionfocusNodes);
                      },
                      focusNode: _pricefocusNodes,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please  enter a price";
                        }
                        if (double.tryParse(value) == null) {
                          return "please  enter a valid price";
                        }
                        if (double.tryParse(value) <= 0) {
                          return "please  enter a valid price";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editeddata = Product(
                          imageUrl: _editeddata.imageUrl,
                          description: _editeddata.description,
                          title: _editeddata.title,
                          price: double.parse(value),
                          id: _editeddata.id,
                          isfavorite: _editeddata.isfavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['description'],
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionfocusNodes,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please  enter a description";
                        }
                        if (value.length < 10) {
                          return "should be at least 10 charactors long.";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editeddata = Product(
                          imageUrl: _editeddata.imageUrl,
                          description: value,
                          title: _editeddata.title,
                          price: _editeddata.price,
                          id: _editeddata.id,
                          isfavorite: _editeddata.isfavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(right: 10, top: 8),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(child: Text("Enter an Image"))
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(
                              labelText: "Image Url",
                            ),
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlfocusNodes,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "please  enter a Image Url";
                              }
                              if ((!value.startsWith("http") &&
                                  !value.startsWith("https"))) {
                                return "please Enter a valid url";
                              }
                              if ((!value.startsWith("http") &&
                                  !value.startsWith("https"))) {
                                return "please Enter a valid url";
                              }
                              if ((!value.endsWith(".png") &&
                                  !value.endsWith(".jpg") &&
                                  !value.endsWith(".jpeg"))) {
                                return "please Enter a valid url";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _editeddata =Product(
                                imageUrl: value,
                                description: _editeddata.description,
                                title: _editeddata.title,
                                price: _editeddata.price,
                                id: _editeddata.id,
                                isfavorite: _editeddata.isfavorite,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
    );
  }
}
