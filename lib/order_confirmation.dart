import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/cart_item_model.dart';

class OrderConfirmationPage extends StatelessWidget {
  final List<CartItem> itemsToCheckout;
  
  const OrderConfirmationPage({super.key, required this.itemsToCheckout});

  @override
  Widget build(BuildContext context) {
    const double shippingCost = 15000;
    final double subtotal = itemsToCheckout.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final double totalAmount = subtotal + shippingCost;
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (UI untuk alamat, metode pembayaran, dll.)
            const Text('Ringkasan Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...itemsToCheckout.map((item) => _buildOrderItem(item, formatCurrency)),
            const Divider(height: 32),
            _buildSummaryRow('Subtotal', formatCurrency.format(subtotal)),
            _buildSummaryRow('Ongkos Kirim', formatCurrency.format(shippingCost)),
            const Divider(height: 16),
            _buildSummaryRow('Total Pembayaran', formatCurrency.format(totalAmount), isTotal: true),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Mengirim `true` kembali ke halaman sebelumnya untuk menandakan konfirmasi
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: const Text('Konfirmasi & Bayar'),
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item, NumberFormat formatCurrency) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Jumlah: ${item.quantity}'),
              ],
            ),
          ),
          Text(formatCurrency.format(item.price * item.quantity)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
