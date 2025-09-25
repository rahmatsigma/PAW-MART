import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/cart_item_model.dart';
import 'models/cart_service.dart';
import 'order_succes.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  List<CartItem> _cartItems = [];
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _cartItems = CartService.getItems();
  }

  Widget _buildAddressCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  'Alamat Pengiriman',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Riski RahmatSigma (+62) 812-3456-7890',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Jl. Pahlawan No. 123, Madiun, Jawa Timur, 63117',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Rincian Produk',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  leading: Image.network(item.food.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item.food.name),
                  subtitle: Text('Jumlah: ${item.quantity}'),
                  trailing: Text(formatCurrency.format(item.food.price * item.quantity)),
                );
              },
              separatorBuilder: (context, index) => const Divider(indent: 16, endIndent: 16),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPaymentMethod() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.payment_outlined, color: Colors.deepPurple),
        title: const Text('Metode Pembayaran'),
        subtitle: const Text('Pilih Metode Pembayaran', style: TextStyle(color: Colors.black54)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
        },
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal) {
    const double shippingCost = 15000;
    final double total = subtotal + shippingCost;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rincian Pembayaran',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal Produk'),
                Text(formatCurrency.format(subtotal)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Biaya Pengiriman'),
                Text(formatCurrency.format(shippingCost)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  formatCurrency.format(total),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = 0;
    for (var item in _cartItems) {
      subtotal += item.food.price * item.quantity;
    }
    const double shippingCost = 15000;
    final double total = subtotal + shippingCost;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressCard(),
            _buildProductList(),
            _buildPaymentMethod(),
            _buildOrderSummary(subtotal),
            const SizedBox(height: 80), 
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
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
                const Text('Total Pembayaran:'),
                Text(
                  formatCurrency.format(total),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
  // 1. Buat ID Pesanan sederhana (contoh: INV-25092025-1959)
  final String orderId = 'INV-${DateFormat('ddMMyyyy-HHmm').format(DateTime.now())}';

  // 2. Kosongkan keranjang
  CartService.clearCart();

  // 3. Pindah ke halaman sukses dan ganti halaman checkout saat ini
  // Kita pakai pushReplacement agar user tidak bisa kembali ke halaman checkout
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => OrderSuccessPage(
        orderedItems: _cartItems,
        totalAmount: total, // `total` dari variabel di method build
        orderId: orderId,
      ),
    ),
  );
},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Buat Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}