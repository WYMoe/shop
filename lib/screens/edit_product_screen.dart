import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {


  FocusNode _priceFocus;

  FocusNode _descriptionFocus;

  FocusNode _urlFocus;

  TextEditingController _urlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var productToSubmit = WillSubmitProduct();




  void _saveForm(){
      _formKey.currentState.save();
      Product product = Product(
        id: productToSubmit.title,
        price: productToSubmit.price,
        title: productToSubmit.title,
        imageUrl: productToSubmit.imageUrl,
        description: productToSubmit.description,
        isFavourite: productToSubmit.isFavourite
      );
      print(product.title);

  }


  @override
  void initState() {
    // TODO: implement initState

    _priceFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _urlFocus = FocusNode();
    _urlFocus.addListener(() {

      if(!_urlFocus.hasFocus){
        setState(() {

        });
      }

    });
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _urlFocus.dispose();
    _urlController.dispose();
    _urlFocus.removeListener(() {

    });

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon((Icons.save)),
            onPressed: (){
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Title', border: OutlineInputBorder(),

              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_){
                _priceFocus.requestFocus();

              },

              onSaved: (title) {
                productToSubmit.title = title;



              },


            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Price', border: OutlineInputBorder(),
              ),
              focusNode: _priceFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_){
                _descriptionFocus.requestFocus();
              },
              onSaved: (price){
                productToSubmit.price = double.parse(price);


              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
              focusNode: _descriptionFocus,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              onFieldSubmitted: (_){
                _urlFocus.requestFocus();

              },

              onSaved: (des){
                productToSubmit.description = des;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.3,
                  height: MediaQuery.of(context).size.height*0.2,

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    )
                  ),
                  child: _urlController.text.isEmpty?null:FittedBox(
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
                        labelText: 'ImageUrl', border: OutlineInputBorder()

                    ),
                    focusNode: _urlFocus,
                    controller: _urlController,
                    onSaved: (url){
                      productToSubmit.imageUrl = url;
                    },

                  ),
                ),

              ],
            )
          ],
        )),
      ),
    );
  }
}

class WillSubmitProduct{
   String id;
   String title;
   String description;
   double price;
   String imageUrl;
  bool isFavourite;

  WillSubmitProduct({this.id, this.title, this.description, this.price, this.imageUrl,
    this.isFavourite = false});
}