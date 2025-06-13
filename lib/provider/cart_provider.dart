import 'package:flutter/material.dart';
import 'package:pharma/model/card_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  int get totalDistinctItems => _cartItems.length;

  void addToCart(CartItem product, int quantity) {
    final existingProductIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingProductIndex != -1) {
      _cartItems[existingProductIndex].quantity += quantity;

      if (_cartItems[existingProductIndex].quantity <= 0) {
        _cartItems.removeAt(existingProductIndex);
      }
    } else if (quantity > 0) {
      _cartItems.add(
        CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          image: product.image,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
