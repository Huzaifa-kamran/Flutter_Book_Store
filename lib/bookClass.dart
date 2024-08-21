class Book {
  final String id; // Unique identifier
  final String title;
  final String author;
  final String imageUrl;
  final double price;
  int quantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  // Empty constructor for placeholder purposes
  Book.empty()
      : id = '',
        title = '',
        author = '',
        imageUrl = '',
        price = 0.0,
        quantity = 0;

  // Copy constructor
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;

  // Convert the book to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  // Convert a map to a Book instance
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 1,
    );
  }

  // Override equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
