import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderHistory {
  final String id;
  final String date;
  final String productName;
  final String imageUrl;
  final double total;
  final String status;

  OrderHistory({
    required this.id,
    required this.date,
    required this.productName,
    required this.imageUrl,
    required this.total,
    required this.status,
  });
}

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final List<OrderHistory> _orders = [
    OrderHistory(
      id: 'INV-25092025-1959',
      date: '25 Sep 2025',
      productName: 'Royal Canin Adult',
      imageUrl: 'assets/images/royalcanin.png', 
      total: 165000,
      status: 'Selesai',
    ),
    OrderHistory(
      id: 'INV-24092025-1130',
      date: '24 Sep 2025',
      productName: 'Whiskas Adult Indoor',
      imageUrl: 'assets/images/whiskas.png', 
      total: 60000,
      status: 'Selesai',
    ),
    OrderHistory(
      id: 'INV-22092025-0815',
      date: '22 Sep 2025',
      productName: 'TetraMin Tropical Flakes',
      imageUrl: 'assets/images/tetramin.jpg', 
      total: 95000,
      status: 'Dibatalkan',
    ),
  ];

  void _showRatingDialog(OrderHistory order) {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0;
        final reviewController = TextEditingController();

        return AlertDialog(
          title: const Text('Beri Ulasan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(order.imageUrl, height: 80),
                const SizedBox(height: 8),
                Text(order.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Seberapa puas kamu?'),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    rating = rating;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Tulis ulasanmu di sini...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Rating: $rating');
                print('Ulasan: ${reviewController.text}');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terima kasih atas ulasan Anda!')),
                );
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(order.status, style: TextStyle(
                        color: order.status == 'Selesai' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Image.network(order.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.productName, style: const TextStyle(fontSize: 16)),
                            Text('Tanggal: ${order.date}'),
                            Text('Total: Rp ${order.total.toStringAsFixed(0)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (order.status == 'Selesai')
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showRatingDialog(order),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text('Beri Ulasan'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}