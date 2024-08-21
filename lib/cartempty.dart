import 'package:flutter/foundation.dart';
import 'bookClass.dart';

class Cartempty extends ChangeNotifier {
  List<Book> _items = [];

  List<Book> get items => _items;

  Future<void> checkout(String email) async {
    // Simulate a checkout process (you can replace this with actual logic)
    await Future.delayed(Duration(seconds: 2));
    clearCart(); // Clear cart after checkout
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(Book book) {
    return _items.any((item) => item.id == book.id);
  }
}
