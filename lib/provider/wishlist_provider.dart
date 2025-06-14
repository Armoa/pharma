import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/wishlist_service.dart';

class WishlistProvider with ChangeNotifier {
  List<WishlistItem> _wishlist = [];
  List<WishlistItem> get wishlist => _wishlist;
  Future<void> saveWishlistToLocalStorage(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = _wishlist.map((item) => item.toJson()).toList();
    prefs.setString(
      'wishlist_$userId',
      json.encode(wishlistJson),
    ); // Usar el userId recibido como parámetro
  }

  Future<void> loadWishlistFromLocalStorage(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = prefs.getString(
      'wishlist_$userId',
    ); // Cargar usando el userId

    if (wishlistJson != null) {
      final List<dynamic> decodedJson = json.decode(wishlistJson);
      _wishlist =
          decodedJson.map((item) => WishlistItem.fromJson(item)).toList();
    } else {
      _wishlist = []; // Inicializar como vacía si no hay datos para el usuario
    }
    notifyListeners(); // Notificar cambios a la UI
  }

  void addToWishlist(WishlistItem item, String userId) async {
    _wishlist.add(item);
    await saveWishlistToLocalStorage(userId); // Guardar después de agregar
    notifyListeners();
  }

  void removeFromWishlist(String id, String userId) async {
    _wishlist.removeWhere((item) => item.id == id);
    await saveWishlistToLocalStorage(userId); // Guardar después de eliminar
    notifyListeners();
  }

  void addItemToWishlist(WishlistItem item, String userId) async {
    _wishlist.add(item);
    await WishlistService().saveWishlistToLocalStorage(
      userId,
      _wishlist,
    ); // Guardar la lista actualizada
    notifyListeners();
  }
}
