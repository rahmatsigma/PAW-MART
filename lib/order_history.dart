import 'package:flutter/material.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _firestoreService.getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Anda belum memiliki riwayat pesanan.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('dd MMMM yyyy, HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          'Pesanan #${order.id.substring(0, 8)}', // Tampilkan 8 karakter pertama ID
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(formatDate.format(order.orderDate)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatCurrency.format(order.totalPrice),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Text(order.status),
          ],
        ),
        children: order.items.map((item) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                item.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(item.name),
            subtitle: Text('${item.quantity} x ${formatCurrency.format(item.price)}'),
          );
        }).toList(),
      ),
    );
  }
}
