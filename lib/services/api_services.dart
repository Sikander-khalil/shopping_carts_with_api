import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/product_model.dart';

class APIServices {
  static const String baseURL = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseURL/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product(
        id: json['id'],
        title: json['title'],
        price: json['price'].toDouble(),
        image: json['image'],
      )).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }


}



