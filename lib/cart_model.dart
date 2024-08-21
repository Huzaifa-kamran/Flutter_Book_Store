import 'package:bookstore/bookClass.dart';
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Book> _items = [];

  List<Book> get items => _items;

  // Check if a book is in the cart by comparing its unique identifier or title
  bool isInCart(Book book) {
    return _items.any((item) => item.title == book.title);
  }

  // Add a book to the cart or increase its quantity if it's already there
  void add(Book book) {
    final existingBook = _items.firstWhere(
      (item) => item.title == book.title,
      orElse: () => Book.empty(), // Assuming you have an empty Book constructor
    );

    if (existingBook.title.isNotEmpty) {
      increaseQuantity(existingBook);
    } else {
      _items.add(book);
      notifyListeners(); // Notify only when a new item is added
    }
  }

  // Remove a book from the cart
  void remove(Book book) {
    _items.remove(book);
    notifyListeners(); // Notify only when an item is removed
  }

  // Increase the quantity of a book in the cart
  void increaseQuantity(Book book) {
    book.quantity++;
    notifyListeners(); // Notify after increasing quantity
  }

  // Decrease the quantity of a book in the cart
  void decreaseQuantity(Book book) {
    if (book.quantity > 1) {
      book.quantity--;
    } else {
      remove(book); // Remove the book if the quantity drops to zero
    }
    notifyListeners(); // Notify after decreasing quantity
  }

  // Get the total amount of all books in the cart
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Clear the cart
  void clearCart() {
    _items.clear();
    notifyListeners(); // Notify listeners after clearing the cart
  }
}
