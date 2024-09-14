import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  // Danh sách các sản phẩm trong giỏ hàng
  List<String> _cartItems = [];

  // Phương thức để lấy danh sách các sản phẩm trong giỏ hàng
  List<String> get cartItems => _cartItems;

  // Phương thức để thêm sản phẩm vào giỏ hàng
  void addToCart(String productId) {
    _cartItems.add(productId);
    notifyListeners();
  }

  // Phương thức để xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  // Phương thức để kiểm tra xem một sản phẩm có trong giỏ hàng không
  bool isInCart(String productId) {
    return _cartItems.contains(productId);
  }

  // Phương thức để xóa tất cả sản phẩm khỏi giỏ hàng
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}