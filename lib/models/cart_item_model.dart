import 'package:myapp/models/product_model.dart';

class CartItem {
  final String id; // ID dari dokumen di sub-koleksi cart
  final String productId;
  final String name;
  final int price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  // Mengubah object CartItem menjadi Map agar bisa disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  // Membuat object CartItem dari object Product
  // Ini digunakan saat menambahkan produk baru ke keranjang
  factory CartItem.fromProduct(Product product, {required int quantity}) {
    return CartItem(
      id: '', // ID akan dibuat otomatis oleh Firestore, jadi bisa dikosongkan
      productId: product.id,
      name: product.name,
      price: product.price.toInt(),
      imageUrl: product.imageUrl,
      quantity: quantity,
    );
  }

  // Membuat object CartItem dari data Map yang diambil dari Firestore
  factory CartItem.fromMap(String id, Map<String, dynamic> data) {
    return CartItem(
      id: id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? 'No Name',
      price: data['price'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }
}

