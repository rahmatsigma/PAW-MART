import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/cart_item_model.dart';

class OrderModel {
  final String id;
  final DateTime orderDate;
  final double totalPrice;
  final String status;
  final List<CartItem> items;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> data, List<CartItem> items) {
    return OrderModel(
      id: id,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'Unknown',
      items: items,
    );
  }
}

