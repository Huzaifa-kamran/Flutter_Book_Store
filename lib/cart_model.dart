import 'package:flutter/foundation.dart';
import 'bookClass.dart';

class CartModel extends ChangeNotifier {
  List<Book> _items = [];

  List<Book> get items => _items;

  double get totalAmount {
    return _items.fold(
        0, (total, current) => total + (current.price * current.quantity));
  }

  void add(Book book) {
    _items.add(book);
    notifyListeners();
  }

  void remove(Book book) {
    _items.remove(book);
    notifyListeners();
  }

  void increaseQuantity(Book book) {
    final index = _items.indexOf(book);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Book book) {
    final index = _items.indexOf(book);
    if (index != -1 && _items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

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
