import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.isFavourite = false});

  void toggleFavourite() async {
    var temp = isFavourite;

    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final url =
          "https://e-commerce-69833-default-rtdb.firebaseio.com/product/$id.json";
      var response = await http.patch(url,
          body: jsonEncode({
            'isFavourite': isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = temp;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = temp;
      notifyListeners();
      throw (error);
    }

  }

  factory Product.fromJSON(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      title: map['title'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      isFavourite: map['isFavourite'],
    );
  }
}
