import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    _refreshOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = _firestoreService.getOrderHistory();
    });
  }

  void _showRatingDialog(OrderModel order) {
    // Menyimpan rating sementara untuk setiap produk
    final Map<String, double> productRatings = {};
    for (var item in order.items) {
      productRatings[item.productId] = 3.0; // Default rating
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Beri Penilaian Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          productRatings[item.productId] = rating;
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nanti Saja'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog dulu
                try {
                  for (var entry in productRatings.entries) {
                    await _firestoreService.submitProductRating(entry.key, entry.value);
                  }
                   if(mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terima kasih atas penilaian Anda!'), backgroundColor: Colors.green),
                    );
                   }
                } catch (e) {
                  if(mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal mengirim penilaian: $e')),
                    );
                  }
                }
              },
              child: const Text('Kirim Penilaian'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.white,
        elevation: 0.5,
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Anda belum memiliki riwayat pesanan.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              )
            );
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
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

  // --- WIDGET KARTU PESANAN YANG BARU (TANPA DROPDOWN) ---
  Widget _buildOrderCard(OrderModel order) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('dd MMMM yyyy, HH:mm');
    final isCompleted = order.status == 'Selesai';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian Header Kartu ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pesanan #${order.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.orange.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
            Text(
              formatDate.format(order.orderDate),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Divider(height: 24),

            // --- Daftar Produk (langsung ditampilkan) ---
            Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text('${item.quantity} x ${formatCurrency.format(item.price)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(),

            // --- Bagian Total Harga ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Pesanan:', style: TextStyle(color: Colors.grey[700])),
                Text(
                  formatCurrency.format(order.totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),

            // --- Tombol "Pesanan Diterima" (hanya jika belum selesai) ---
            if (!isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _firestoreService.updateOrderStatus(order.id, 'Selesai');
                      if(mounted) {
                        _showRatingDialog(order);
                        _refreshOrders(); // Refresh daftar pesanan
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Pesanan Diterima'),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

