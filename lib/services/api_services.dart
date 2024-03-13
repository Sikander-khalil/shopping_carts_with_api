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

  // Future<int> addToCart(int userId, List<Map<String, dynamic>> products) async {
  //   final response = await http.post(
  //     Uri.parse('$baseURL/carts'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'userId': userId, 'products': products}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     return data['id'];
  //   } else {
  //     throw Exception('Failed to add to cart');
  //   }
  // }
  //
  // Future<void> updateCart(int cartId, int userId, List<Map<String, dynamic>> products) async {
  //   await http.put(
  //     Uri.parse('$baseURL/carts/$cartId'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'userId': userId, 'products': products}),
  //   );
  // }
  //
  // Future<void> deleteCart(int cartId) async {
  //   await http.delete(Uri.parse('$baseURL/carts/$cartId'));
  // }
}



