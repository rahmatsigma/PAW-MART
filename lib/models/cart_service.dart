import 'package:flutter/foundation.dart'; 
import 'package:myapp/models/pet_food_model.dart';
import 'package:intl/intl.dart'; 
import 'cart_item_model.dart';

class CartService {
  static final List<CartItem> _cartItems = [];

  static final ValueNotifier<int> cartItemCountNotifier =
      ValueNotifier(_calculateTotalItems());

  static int _calculateTotalItems() {
    if (_cartItems.isEmpty) return 0;
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  static void _notifyListeners() {
    cartItemCountNotifier.value = _calculateTotalItems();
  }

  static List<CartItem> getItems() {
    return List.from(_cartItems);
  }

  static void addItemAt(int index, CartItem item) {
    _cartItems.insert(index, item);
    _notifyListeners(); 
  }

  static void removeItem(CartItem item) {
    _cartItems.remove(item);
    _notifyListeners(); 
  }

  static void addItemFromPetFood(PetFoodModel petFood) {
    final index = _cartItems.indexWhere((item) => item.food.id == petFood.id);
    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(CartItem(food: petFood, quantity: 1));
    }
    _notifyListeners(); 
  }

  static void decreaseQuantity(CartItem item) {
    final idx = _cartItems.indexOf(item);
    if (idx != -1) {
      if (_cartItems[idx].quantity > 1) {
        _cartItems[idx].quantity -= 1;
      } else {
        _cartItems.removeAt(idx);
      }
      _notifyListeners(); 
    }
  }

  static void increaseQuantity(CartItem item) {
    final idx = _cartItems.indexOf(item);
    if (idx != -1) {
      _cartItems[idx].quantity += 1;
      _notifyListeners(); 
    }
  }

  static void clearCart() {
    _cartItems.clear();
    _notifyListeners(); 
  }

  static double getTotalPrice() {
    return _cartItems.fold(0, (sum, item) => sum + item.food.price * item.quantity);
  }

  static String getFormattedTotalPrice() {
    final total = getTotalPrice();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(total);
  }

  static void removeMultipleItems(List<CartItem> itemsToRemove) {
    _cartItems.removeWhere((item) => itemsToRemove.contains(item));
    _notifyListeners(); 
  }
}