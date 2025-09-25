import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/cart_item_model.dart'; 

class OrderSuccessPage extends StatelessWidget {
  final List<CartItem> orderedItems;
  final double totalAmount;
  final String orderId;

  const OrderSuccessPage({
    super.key,
    required this.orderedItems,
    required this.totalAmount,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pesanan'),
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSuccessHeader(),
            const SizedBox(height: 24),
            _buildOrderDetailCard(orderId, formatCurrency),
            const SizedBox(height: 16),
            _buildProductListCard(formatCurrency),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildSuccessHeader() {
    return const Column(
      children: [
        Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
        SizedBox(height: 16),
        Text(
          'Pesanan Berhasil Dibuat!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Terima kasih! Kami akan segera memproses pesanan Anda.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOrderDetailCard(String orderId, NumberFormat formatCurrency) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DETAIL PESANAN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ID Pesanan:'),
                Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tanggal Pesanan:'),
                Text(DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran:'),
                Text(formatCurrency.format(totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListCard(NumberFormat formatCurrency) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PRODUK YANG DIPESAN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
            const Divider(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderedItems.length,
              itemBuilder: (context, index) {
                final item = orderedItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Image.network(item.food.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Jumlah: ${item.quantity}'),
                          ],
                        ),
                      ),
                      Text(formatCurrency.format(item.food.price * item.quantity)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Kembali ke Beranda'),
        ),
      ),
    );
  }
}