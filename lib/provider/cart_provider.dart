import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cart_item_model.dart';
import '../model/product_model.dart';
import '../services/api_services.dart';



class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<Product> _products = [];
  late SharedPreferences _preferences;

  CartProvider() {
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();

    _loadCartFromStorage();
  }

  Future<void> _loadCartFromStorage() async {
    final String cartData = _preferences.getString('cart') ?? '[]';
    final List<dynamic> decodedData = json.decode(cartData);
    _cartItems = decodedData.map((item) => CartItem.fromJson(item)).toList();
    notifyListeners();
  }

  Future<void> _saveCartToStorage() async {
    final String cartData = json.encode(_cartItems);
    await _preferences.setString('cart', cartData);
  }



  Future<void> fetchProducts() async {
    try {
      _products = await APIServices().fetchProducts();
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }


  List<CartItem> get cartItems => _cartItems;
  void addToCart(Product product) {
    int index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }

    print('Cart items after adding: $_cartItems');
    _saveCartToStorage();

    notifyListeners();
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity += 1;
    _saveCartToStorage();
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity -= 1;
    } else {
      _cartItems.remove(cartItem);
    }
    _saveCartToStorage();
    notifyListeners();

  }

  void deleteCartItem(int productId) {
      _cartItems.removeWhere((item) => item.product.id == productId);
    _saveCartToStorage();
    notifyListeners();
  }

  double getProductPriceById(int productId) {
    if (_products.isEmpty) {
      return 0.0;
    }
    Product product = _products.firstWhere((prod) => prod.id == productId);
    return product.price;
  }

  String getProductTitleById(int productId) {
    CartItem cartItem = _cartItems.firstWhere((item) => item.product.id == productId);
    return cartItem.product.title;
  }




  double calculateItemTotalPrice(CartItem cartItem) {
    return cartItem.product.price * cartItem.quantity;
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (CartItem cartItem in _cartItems) {
      total += calculateItemTotalPrice(cartItem);
    }
    return total;
  }


}
