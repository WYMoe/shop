import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  FocusNode _titleFocus;
  FocusNode _priceFocus;

  FocusNode _descriptionFocus;

  FocusNode _urlFocus;

  TextEditingController _urlController = TextEditingController();

  String newTitle;
  String newDescription;
  double newPrice;
  String newImageUrl;

  final _formKey = GlobalKey<FormState>();

  void _saveForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Provider.of<ProductsProvider>(context, listen: false).addProduct(
          DateTime.now().toString(),
          newTitle,
          newDescription,
          newPrice,
          newImageUrl);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _titleFocus = FocusNode();

    _priceFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _urlFocus = FocusNode();
    _titleFocus.addListener(() {
      setState(() {});
    });
    _descriptionFocus.addListener(() {
      setState(() {});
    });

    _urlFocus.addListener(_updateUrl);
    super.initState();
  }

  _updateUrl() {
    if (!_urlFocus.hasFocus) {
      if ((!_urlController.text.startsWith('http') &&
              !_urlController.text.startsWith('https')) ||
          (!_urlController.text.endsWith('.png') &&
              !_urlController.text.endsWith('.jpg') &&
              !_urlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _urlFocus.removeListener(_updateUrl);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _urlFocus.dispose();
    _urlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon((Icons.save)),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelStyle: TextStyle(
                          color: _titleFocus.hasFocus
                              ? Colors.blueGrey
                              : Colors.blueGrey),
                      labelText: 'Title',
                      fillColor: Colors.blueGrey[30],
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey)),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    focusNode: _titleFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _priceFocus.requestFocus();
                    },
                    validator: (title) {
                      if (title.isEmpty) {
                        return "Please enter title";
                      }
                      return null;
                    },
                    onSaved: (title) {
                      newTitle = title;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: _priceFocus.hasFocus
                              ? Colors.blueGrey
                              : Colors.blueGrey),
                      labelText: 'Price',
                      filled: true,
                      fillColor: Colors.blueGrey[30],
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey)),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    focusNode: _priceFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) {
                      _descriptionFocus.requestFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a price.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than zero.';
                      }
                      return null;
                    },
                    onSaved: (price) {
                      newPrice = double.parse(price);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: _descriptionFocus.hasFocus
                              ? Colors.blueGrey
                              : Colors.blueGrey),
                      labelText: 'Description',
                      filled: true,
                      fillColor: Colors.blueGrey[30],
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey)),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    focusNode: _descriptionFocus,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    onFieldSubmitted: (_) {
                      _urlFocus.requestFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description.';
                      }
                      if (value.length < 10) {
                        return 'Should be at least 10 characters long.';
                      }
                      return null;
                    },
                    onSaved: (des) {
                      newDescription = des;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey)),
                        child: _urlController.text.isEmpty
                            ? null
                            : FittedBox(
                                child: Image.network(_urlController.text),
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: _urlFocus.hasFocus
                                    ? Colors.blueGrey
                                    : Colors.blueGrey),
                            labelText: 'ImageUrl',
                            filled: true,
                            fillColor: Colors.blueGrey[30],
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey)),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          focusNode: _urlFocus,
                          controller: _urlController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an image URL.';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please enter a valid URL.';
                            }
                            if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please enter a valid image URL.';
                            }
                            return null;
                          },
                          onSaved: (url) {
                            newImageUrl = url;
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
