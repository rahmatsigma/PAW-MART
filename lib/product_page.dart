import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/firestore_service.dart';

class ProductPage extends StatefulWidget {
  final String? initialCategory;

  const ProductPage({super.key, this.initialCategory});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Product>> _productsFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _productsFuture = _firestoreService.getProducts();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Kami'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk.'));
          }

          final allProducts = snapshot.data!;
          final filteredProducts = _selectedCategory == null
              ? allProducts
              : allProducts.where((p) => p.category == _selectedCategory).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return _buildProductCard(product, formatCurrency);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, NumberFormat formatCurrency) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              // Menambahkan loading builder untuk user experience yang lebih baik
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              // Menambahkan error builder jika gambar gagal dimuat
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  formatCurrency.format(product.price),
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                _firestoreService.addToCart(product, 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} ditambahkan ke keranjang.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Add to Cart'),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
