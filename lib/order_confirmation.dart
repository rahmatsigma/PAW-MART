import 'package:flutter/material.dart';
import 'models/cart_item_model.dart';
import 'models/cart_service.dart';
import 'package:intl/intl.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _cartItems = CartService.getItems();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    double total = 0;
    for (var item in _cartItems) {
      total += item.food.price * item.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rincian Produk:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
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
              ),
            ),
            const Divider(thickness: 1.2),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Harga:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(formatCurrency.format(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Pesanan Dikonfirmasi'),
                      content: const Text('Terima kasih sudah melakukan pemesanan!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(); 
                            CartService.clearCart(); 
                          },
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Konfirmasi & Bayar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
