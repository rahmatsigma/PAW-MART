import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/cart_item_model.dart';
import 'package:myapp/services/firestore_service.dart';
import 'order_confirmation.dart';
import 'order_succes.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final Set<CartItem> _selectedItems = {};

  void _onItemSelected(List<CartItem> currentCart, CartItem item, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        _selectedItems.add(item);
      } else {
        _selectedItems.removeWhere((selected) => selected.id == item.id);
      }
    });
  }

  void _toggleSelectAll(List<CartItem> currentCart, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        _selectedItems.addAll(currentCart);
      } else {
        _selectedItems.clear();
      }
    });
  }

  void _removeItem(CartItem item) {
    _firestoreService.removeFromCart(item.id);
    setState(() {
      _selectedItems.removeWhere((selected) => selected.id == item.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} dihapus dari keranjang')),
    );
  }

  void _checkoutSelectedItems() async {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih setidaknya satu item untuk checkout.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final List<CartItem> itemsToCheckout = _selectedItems.toList();
    
    // Navigasi ke halaman konfirmasi
    final bool? checkoutConfirmed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(itemsToCheckout: itemsToCheckout),
      ),
    );

    // Jika user mengkonfirmasi di halaman berikutnya
    if (checkoutConfirmed == true && mounted) {
      final double totalAmount = itemsToCheckout.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
      final String orderId = 'INV-${DateFormat('ddMMyyyy-HHmm').format(DateTime.now())}';

      // Panggil fungsi placeOrder
      await _firestoreService.placeOrder(itemsToCheckout, totalAmount);
      
      setState(() {
        _selectedItems.clear();
      });

      // Navigasi ke halaman sukses
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSuccessPage(
            orderedItems: itemsToCheckout,
            totalAmount: totalAmount,
            orderId: orderId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: _firestoreService.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyCartView();
          }

          final cartItems = snapshot.data!;
          // Membersihkan item terpilih yang mungkin sudah tidak ada di keranjang
          _selectedItems.removeWhere((selected) => !cartItems.any((cart) => cart.id == selected.id));
          bool isAllSelected = cartItems.isNotEmpty && _selectedItems.length == cartItems.length;

          return Column(
            children: [
              _buildSelectAllHeader(cartItems, isAllSelected),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final bool isSelected = _selectedItems.any((selected) => selected.id == item.id);
                    return _buildCartItemCard(item, isSelected, cartItems);
                  },
                ),
              ),
              _buildSummaryCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectAllHeader(List<CartItem> currentCart, bool isAllSelected) {
     return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Checkbox(
            value: isAllSelected,
            onChanged: (val) => _toggleSelectAll(currentCart, val),
            activeColor: Theme.of(context).primaryColor,
          ),
          const Text('Pilih Semua', style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildEmptyCartView() {
    // ... (kode tidak berubah)
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

  Widget _buildCartItemCard(CartItem item, bool isSelected, List<CartItem> cartItems) {
    // ... (logika UI sebagian besar sama, hanya akses data yang berubah)
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Dismissible(
      key: Key(item.id), // Gunakan ID dari Firestore
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _removeItem(item),
      background: Container(
        // ... (kode tidak berubah)
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
        // ... (kode tidak berubah)
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (bool? value) => _onItemSelected(cartItems, item, value),
                activeColor: Theme.of(context).primaryColor,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(item.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(formatCurrency.format(item.price), style: const TextStyle(color: Colors.green, fontSize: 14)),
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
          onPressed: () => _firestoreService.updateItemQuantity(item.id, -1),
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 28),
        ),
        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        IconButton(
          onPressed: () => _firestoreService.updateItemQuantity(item.id, 1),
          icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 28),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    // ... (kode tidak berubah, hanya akses data yang berbeda)
    final double totalPrice = _selectedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final String formattedTotalPrice = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(totalPrice);
    
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
                  formattedTotalPrice,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _checkoutSelectedItems,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text('Checkout (${_selectedItems.length})'),
            ),
          ],
        ),
      ),
    );
  }
}
