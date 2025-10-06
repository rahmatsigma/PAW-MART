import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/cart_item_model.dart';
import 'order_succes.dart';

class QrPaymentPage extends StatelessWidget {
  final double totalAmount;
  final String orderId;
  final List<CartItem> orderedItems;

  const QrPaymentPage({
    super.key,
    required this.totalAmount,
    required this.orderId,
    required this.orderedItems,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox( 
          width: double.infinity, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Scan untuk Membayar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Order ID: $orderId',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${formatCurrency.format(totalAmount)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 24),
              Image.asset(
                'assets/images/qris.png', 
                width: 250,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Gagal memuat gambar QR.',
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Gunakan aplikasi E-Wallet (GoPay, OVO, Dana, dll) atau M-Banking Anda untuk melakukan scan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSuccessPage(
                  orderedItems: orderedItems,
                  totalAmount: totalAmount,
                  orderId: orderId,
                ),
              ),
              (route) => false,
            );
          },
          child: const Text('Saya Sudah Bayar'),
        ),
      ),
    );
  }
}