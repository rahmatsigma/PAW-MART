import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; 
import 'package:intl/intl.dart';
import 'package:myapp/order_confirmation.dart';
import 'models/cart_item_model.dart';
import 'models/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    setState(() {
      _cartItems = CartService.getItems();
    });
  }

  void _removeItem(CartItem item) {
    final int index = _cartItems.indexOf(item);
    setState(() {
      _cartItems.remove(item);
    });
    CartService.removeItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.food.name} dihapus'),
        action: SnackBarAction(
          label: 'URUNGKAN',
          onPressed: () {
            setState(() {
              _cartItems.insert(index, item);
            });
            CartService.addItemAt(index, item);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _showClearCartDialog,
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCartView()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItemCard(item)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.2, curve: Curves.easeInOut);
                    },
                  ),
                ),
                _buildSummaryCard()
                    .animate()
                    .slideY(begin: 1, duration: 300.ms, curve: Curves.easeOut),
              ],
            ),
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Keranjang belanja Anda kosong',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms);
  }

  Widget _buildCartItemCard(CartItem item) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Dismissible(
      key: Key(item.food.id.toString()), 
      direction: DismissDirection.endToStart, 
      onDismissed: (direction) {
        _removeItem(item); 
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(item.food.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(formatCurrency.format(item.food.price), style: const TextStyle(color: Colors.green, fontSize: 14)),
                  ],
                ),
              ),
              _buildQuantityControl(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl(CartItem item) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            CartService.decreaseQuantity(item);
            _loadCartItems();
          },
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 28),
        ),
        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
            .animate(target: item.quantity.toDouble())
            .fade(duration: 200.ms),
        IconButton(
          onPressed: () {
            CartService.increaseQuantity(item);
            _loadCartItems();
          },
          icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 28),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Harga', style: TextStyle(color: Colors.grey)),
                Text(
                  CartService.getFormattedTotalPrice(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderConfirmationPage()),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kosongkan Keranjang?'),
        content: const Text('Anda yakin ingin menghapus semua item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              CartService.clearCart();
              _loadCartItems();
              Navigator.of(context).pop();
            },
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }
}
