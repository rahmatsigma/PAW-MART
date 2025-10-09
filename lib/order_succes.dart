import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/cart_item_model.dart';

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
        title: const Text('Pesanan Berhasil'),
        automaticallyImplyLeading: false, // Menyembunyikan tombol kembali
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Terima Kasih!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Pesanan Anda #${orderId.substring(4, 12)} telah berhasil dibuat.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              _buildOrderSummaryCard(formatCurrency),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman beranda dan hapus semua rute sebelumnya
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(NumberFormat formatCurrency) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Pembelian:', style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          ...orderedItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // PERBAIKAN DI SINI: Akses langsung dari 'item'
                    Expanded(child: Text('${item.name} (x${item.quantity})')),
                    Text(formatCurrency.format(item.price * item.quantity)),
                  ],
                ),
              )),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                formatCurrency.format(totalAmount),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
