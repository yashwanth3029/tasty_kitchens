import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_kitchens/models/food_item.dart';
import 'dart:convert';

import 'package:tasty_kitchens/models/restaurant.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({required this.foodItem, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'foodItem': {
        'id': foodItem.id,
        'name': foodItem.name,
        'cost': foodItem.cost,
        'imageUrl': foodItem.imageUrl,
      },
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      foodItem: FoodItem(
        id: json['foodItem']['id'],
        name: json['foodItem']['name'],
        cost: json['foodItem']['cost'],
        imageUrl: json['foodItem']['imageUrl'],
      ),
      quantity: json['quantity'],
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  double get totalCost => _cartItems.fold(
    0,
    (sum, item) => sum + (item.foodItem.cost * item.quantity),
  );

  CartProvider() {
    _loadCartItems();
  }

  void addItem(FoodItem foodItem) {
    int index = _cartItems.indexWhere(
      (item) => item.foodItem.id == foodItem.id,
    );
    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(foodItem: foodItem));
    }
    _saveCartItems();
    notifyListeners();
  }

  void removeItem(String foodItemId) {
    _cartItems.removeWhere((item) => item.foodItem.id == foodItemId);
    _saveCartItems();
    notifyListeners();
  }

  void incrementQuantity(String foodItemId) {
    int index = _cartItems.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index != -1) {
      _cartItems[index].quantity++;
      _saveCartItems();
      notifyListeners();
    }
  }

  void decrementQuantity(String foodItemId) {
    int index = _cartItems.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index != -1 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      _saveCartItems();
      notifyListeners();
    } else if (_cartItems[index].quantity == 1) {
      removeItem(foodItemId);
    }
  }

  void _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartData = jsonEncode(
      _cartItems.map((item) => item.toJson()).toList(),
    );
    prefs.setString('cartData', cartData);
  }

  void _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cartData');
    if (cartData != null) {
      final List<dynamic> decodedData = jsonDecode(cartData);
      _cartItems = decodedData.map((json) => CartItem.fromJson(json)).toList();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems = [];
    _saveCartItems();
    notifyListeners();
  }
}
