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
      return snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  // --- MANAJEMEN KERANJANG (CART) ---
  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> addToCart(Product product, int quantity) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final cartRef = _db.collection('users').doc(userId).collection('cart');
    final cartItem = CartItem.fromProduct(product, quantity: quantity);

    final existingItem = await cartRef
        .where('productId', isEqualTo: cartItem.productId)
        .limit(1)
        .get();

    if (existingItem.docs.isNotEmpty) {
      final docId = existingItem.docs.first.id;
      await cartRef
          .doc(docId)
          .update({'quantity': FieldValue.increment(quantity)});
    } else {
      await cartRef.add(cartItem.toMap());
    }
  }

  Stream<List<CartItem>> getCartItems() {
    final userId = getCurrentUserId();
    if (userId == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> removeFromCart(String cartItemId) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    return _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItemId)
        .delete();
  }

  Future<void> updateItemQuantity(String cartItemId, int change) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final itemRef =
        _db.collection('users').doc(userId).collection('cart').doc(cartItemId);

    final itemDoc = await itemRef.get();
    if (itemDoc.exists) {
      final currentQuantity = itemDoc.data()?['quantity'] ?? 0;
      if (currentQuantity + change <= 0) {
        await removeFromCart(cartItemId);
      } else {
        await itemRef.update({'quantity': FieldValue.increment(change)});
      }
    }
  }

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
  Future<void> placeOrder(List<CartItem> cartItems, double totalPrice) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final ordersRef = _db.collection('users').doc(userId).collection('orders');
    final cartRef = _db.collection('users').doc(userId).collection('cart');

    DocumentReference newOrder = await ordersRef.add({
      'orderDate': Timestamp.now(),
      'totalPrice': totalPrice,
      'status': 'Diproses',
    });

    WriteBatch batch = _db.batch();
    for (var item in cartItems) {
      final orderItemRef = newOrder.collection('orderItems').doc(item.productId);
      batch.set(orderItemRef, item.toMap());
      
      if (item.id.isNotEmpty) {
        batch.delete(cartRef.doc(item.id));
      }
    }

    await batch.commit();
  }

  Future<List<OrderModel>> getOrderHistory() async {
    final userId = getCurrentUserId();
    if (userId == null) return [];

    final ordersSnapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .get();

    List<OrderModel> orders = [];
    for (var orderDoc in ordersSnapshot.docs) {
      final itemsSnapshot =
          await orderDoc.reference.collection('orderItems').get();
      final List<CartItem> items = itemsSnapshot.docs
          .map((itemDoc) => CartItem.fromMap(itemDoc.id, itemDoc.data()))
          .toList();

      orders.add(OrderModel.fromMap(orderDoc.id, orderDoc.data(), items));
    }
    return orders;
  }
  
  // --- FUNGSI BARU DITAMBAHKAN DI SINI ---
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final userId = getCurrentUserId();
    if (userId == null) return;
    await _db
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .update({'status': newStatus});
  }

  Future<void> submitProductRating(String productId, double rating) async {
    final productRef = _db.collection('products').doc(productId);

    return _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(productRef);

      if (!snapshot.exists) {
        throw Exception("Produk tidak ditemukan!");
      }

      int currentRatingCount = (snapshot.data()?['ratingCount'] ?? 0).toInt();
      double currentTotalRating = (snapshot.data()?['totalRating'] ?? 0.0).toDouble();

      int newRatingCount = currentRatingCount + 1;
      double newTotalRating = currentTotalRating + rating;
      
      transaction.update(productRef, {
        'ratingCount': newRatingCount,
        'totalRating': newTotalRating,
      });
    });
  }
}

