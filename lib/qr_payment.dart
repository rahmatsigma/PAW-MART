import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/cart_item_model.dart';
import 'package:myapp/order_succes.dart';
import 'package:myapp/services/firestore_service.dart';

class QrPaymentPage extends StatefulWidget {
  final List<CartItem> itemsToCheckout;
  final double totalAmount;

  const QrPaymentPage({
    super.key,
    required this.itemsToCheckout,
    required this.totalAmount,
  });

  @override
  State<QrPaymentPage> createState() => _QrPaymentPageState();
}

class _QrPaymentPageState extends State<QrPaymentPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  void _handleConfirmPayment() async {
    setState(() => _isLoading = true);
    try {
      // Panggil service untuk membuat pesanan dengan metode QRIS
      await _firestoreService.placeOrder(
        widget.itemsToCheckout,
        widget.totalAmount,
        'QRIS',
      );
      if (mounted) {
        // Jika berhasil, navigasi ke halaman sukses
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => OrderSuccessPage(
              orderedItems: widget.itemsToCheckout,
              totalAmount: widget.totalAmount,
              orderId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
            ),
          ),
          (route) => route.isFirst,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Scan QR Code untuk Membayar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Pembayaran: ${formatCurrency.format(widget.totalAmount)}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    // PERBAIKAN DI SINI: Panggil nama file aset yang benar
                    Image.asset(
                      'assets/images/qris.png', 
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aplikasi: DANA, GoPay, OVO, ShopeePay, Mobile Banking',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleConfirmPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Saya Sudah Membayar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

