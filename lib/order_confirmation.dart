import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/cart_item_model.dart';
import 'package:myapp/order_succes.dart';
import 'package:myapp/services/firestore_service.dart';

// Diubah menjadi StatefulWidget agar bisa interaktif
class OrderConfirmationPage extends StatefulWidget {
  final List<CartItem> itemsToCheckout;

  const OrderConfirmationPage({super.key, required this.itemsToCheckout});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final FirestoreService _firestoreService = FirestoreService();
  
  // State untuk menyimpan pilihan pengguna
  String _selectedShipping = 'Reguler'; 
  bool _isLoading = false;

  // Definisikan biaya pengiriman di sini
  final Map<String, double> _shippingCosts = {
    'Reguler': 15000.0,
    'Express': 25000.0,
    'Kargo': 50000.0,
  };

  void _handlePlaceOrder(double totalAmount) async {
    setState(() { _isLoading = true; });

    try {
      // Panggil service untuk membuat pesanan di Firestore
      await _firestoreService.placeOrder(widget.itemsToCheckout, totalAmount);

      if (mounted) {
        // Jika berhasil, navigasi ke halaman sukses
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => OrderSuccessPage(
              orderedItems: widget.itemsToCheckout,
              totalAmount: totalAmount,
              // Anda bisa generate Order ID yang lebih kompleks nanti
              orderId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
            ),
          ),
          (route) => route.isFirst, // Hapus semua halaman sebelumnya
        );
      }
    } catch (e) {
      // Jika gagal, tampilkan pesan error
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = widget.itemsToCheckout.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final double shippingCost = _shippingCosts[_selectedShipping] ?? 0.0;
    final double totalAmount = subtotal + shippingCost;
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressSection(),
            const SizedBox(height: 12),
            _buildProductList(formatCurrency),
            const SizedBox(height: 12),
            _buildShippingMethod(),
            const SizedBox(height: 12),
            _buildPaymentSummary(subtotal, shippingCost, totalAmount, formatCurrency),
          ],
        ),
      ),
      // Tombol "Buat Pesanan" di bagian bawah, seperti Shopee
      bottomNavigationBar: _buildBottomBar(totalAmount, formatCurrency),
    );
  }

  // WIDGET BARU: Bagian Alamat
  Widget _buildAddressSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alamat Pengiriman', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  // Nanti alamat ini bisa diambil dari data user di Firestore
                  Text(
                    'riski (+62) 812-3456-7890\nJl. Pahlawan No. 123, Kota Pahlawan, 12345',
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  // WIDGET BARU: Daftar Produk
  Widget _buildProductList(NumberFormat formatCurrency) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produk Dipesan (${widget.itemsToCheckout.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 24),
            ...widget.itemsToCheckout.map((item) => _buildOrderItem(item, formatCurrency)),
          ],
        ),
      ),
    );
  }

  // WIDGET BARU: Pilihan Pengiriman
  Widget _buildShippingMethod() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Opsi Pengiriman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            // Loop untuk membuat pilihan radio
            ..._shippingCosts.keys.map((method) => RadioListTile<String>(
              title: Text(method),
              value: method,
              groupValue: _selectedShipping,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedShipping = value;
                  });
                }
              },
              activeColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
      ),
    );
  }

  // WIDGET BARU: Rincian Pembayaran
  Widget _buildPaymentSummary(double subtotal, double shippingCost, double total, NumberFormat format) {
    return Card(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
       child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 24),
            _buildSummaryRow('Subtotal untuk Produk', format.format(subtotal)),
            _buildSummaryRow('Subtotal Pengiriman', format.format(shippingCost)),
            const Divider(height: 20),
            _buildSummaryRow('Total Pembayaran', format.format(total), isTotal: true),
          ],
        ),
      ),
    );
  }
  
  // Widget untuk tombol "Buat Pesanan" di bawah
  Widget _buildBottomBar(double totalAmount, NumberFormat formatCurrency) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Pembayaran', style: TextStyle(color: Colors.grey)),
              Text(
                formatCurrency.format(totalAmount),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : () => _handlePlaceOrder(totalAmount),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white
            ),
            child: _isLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Text('Buat Pesanan'),
          ),
        ],
      ),
    );
  }

  // Widget-widget pembantu yang sudah ada sebelumnya, sedikit disesuaikan
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
                Text('Jumlah: ${item.quantity}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
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
              color: isTotal ? Colors.black : Colors.grey[800]
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

