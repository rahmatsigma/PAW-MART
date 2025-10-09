import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/cart_item_model.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- MANAJEMEN PRODUK ---
  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('products').get();
      return snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  // --- MANAJEMEN KERANJANG (CART) ---

  // Helper untuk mendapatkan user ID saat ini
  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Menambahkan produk ke keranjang
  Future<void> addToCart(Product product, int quantity) async {
    final userId = getCurrentUserId();
    if (userId == null) return; // Jika user tidak login, jangan lakukan apa-apa

    final cartRef = _db.collection('users').doc(userId).collection('cart');
    final cartItem = CartItem.fromProduct(product, quantity: quantity);

    // Cek apakah produk sudah ada di keranjang
    // PERBAIKAN DI SINI: Menggunakan 'cartItem.productId' bukan 'item.productId'
    final existingItem = await cartRef.where('productId', isEqualTo: cartItem.productId).limit(1).get();

    if (existingItem.docs.isNotEmpty) {
      // Jika sudah ada, update quantity
      final docId = existingItem.docs.first.id;
      await cartRef.doc(docId).update({'quantity': FieldValue.increment(quantity)});
    } else {
      // Jika belum ada, tambahkan sebagai item baru
      await cartRef.add(cartItem.toMap());
    }
  }
  
  // Mengambil semua item di keranjang
  Stream<List<CartItem>> getCartItems() {
    final userId = getCurrentUserId();
    if (userId == null) return Stream.value([]); // Kembalikan stream kosong jika tidak login

    return _db.collection('users').doc(userId).collection('cart').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CartItem.fromMap(doc.id, doc.data())).toList();
    });
  }

  // Menghapus item dari keranjang
  Future<void> removeFromCart(String cartItemId) async {
    final userId = getCurrentUserId();
    if (userId == null) return;
    
    return _db.collection('users').doc(userId).collection('cart').doc(cartItemId).delete();
  }

  // FUNGSI BARU: Mengubah kuantitas item di keranjang
  Future<void> updateItemQuantity(String cartItemId, int change) async {
    final userId = getCurrentUserId();
    if (userId == null) return;
    
    final itemRef = _db.collection('users').doc(userId).collection('cart').doc(cartItemId);
    
    // Ambil data item dulu untuk memastikan kuantitas tidak jadi 0 atau negatif
    final itemDoc = await itemRef.get();
    if (itemDoc.exists) {
        final currentQuantity = itemDoc.data()?['quantity'] ?? 0;
        if (currentQuantity + change <= 0) {
            // Jika kuantitas akan menjadi 0 atau kurang, hapus itemnya
            await removeFromCart(cartItemId);
        } else {
            await itemRef.update({'quantity': FieldValue.increment(change)});
        }
    }
  }

  // FUNGSI BARU: Mengosongkan keranjang
  Future<void> clearCart() async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final cartRef = _db.collection('users').doc(userId).collection('cart');
    final snapshot = await cartRef.get();

    WriteBatch batch = _db.batch();
    for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // --- MANAJEMEN PESANAN (ORDER) ---

  // Membuat pesanan baru
  Future<void> placeOrder(List<CartItem> cartItems, double totalPrice) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final ordersRef = _db.collection('users').doc(userId).collection('orders');
    final cartRef = _db.collection('users').doc(userId).collection('cart');

    // Buat dokumen pesanan baru
    DocumentReference newOrder = await ordersRef.add({
      'orderDate': Timestamp.now(),
      'totalPrice': totalPrice,
      'status': 'Diproses',
    });

    // Pindahkan setiap item dari keranjang ke sub-koleksi 'orderItems' di dalam pesanan baru
    WriteBatch batch = _db.batch();
    for (var item in cartItems) {
      final orderItemRef = newOrder.collection('orderItems').doc(item.productId);
      batch.set(orderItemRef, item.toMap());
      // Hapus item dari keranjang
      batch.delete(cartRef.doc(item.id));
    }

    // Jalankan semua operasi sekaligus
    await batch.commit();
  }

  // Mengambil riwayat pesanan
  Future<List<OrderModel>> getOrderHistory() async {
    final userId = getCurrentUserId();
    if (userId == null) return [];

    final ordersSnapshot = await _db.collection('users').doc(userId).collection('orders').orderBy('orderDate', descending: true).get();
    
    List<OrderModel> orders = [];
    for (var orderDoc in ordersSnapshot.docs) {
      // Untuk setiap pesanan, ambil item-itemnya
      final itemsSnapshot = await orderDoc.reference.collection('orderItems').get();
      final List<CartItem> items = itemsSnapshot.docs.map((itemDoc) => CartItem.fromMap(itemDoc.id, itemDoc.data())).toList();
      
      orders.add(OrderModel.fromMap(orderDoc.id, orderDoc.data(), items));
    }
    return orders;
  }
}

