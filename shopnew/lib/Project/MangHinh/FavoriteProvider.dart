import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> favorites = [];

  void toggleFavorite(String product) {
    if (favorites.contains(product)) {
      favorites.remove(product);
    } else {
      favorites.add(product);
    }
    notifyListeners();
  }
}