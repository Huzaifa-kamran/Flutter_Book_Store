import 'package:cloud_firestore/cloud_firestore.dart';
import 'bookClass.dart';

class Order {
  final String id;
  final String userId;
  final List<Book> items;
  final double totalAmount;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>)
          .map((item) => Book.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['totalAmount'] ?? 0.0) as double,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
