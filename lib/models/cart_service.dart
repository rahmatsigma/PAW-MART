import 'package:myapp/models/pet_food_model.dart';
import 'package:myapp/pet_food.dart';

import 'cart_item_model.dart';

class CartService {
  static final List<CartItem> _cartItems = [];

  static List<CartItem> getItems() {
    return List.from(_cartItems);
  }

  static void addItemAt(int index, CartItem item) {
    _cartItems.insert(index, item);
  }

  static void removeItem(CartItem item) {
    _cartItems.remove(item);
  }

static void addItemFromPetFood(PetFoodModel petFood) {
  final index = _cartItems.indexWhere((item) => item.food.id == petFood.id);
  if (index != -1) {
    _cartItems[index].quantity += 1;
  } else {
    _cartItems.add(CartItem(food: petFood, quantity: 1));
  }
}


  static void decreaseQuantity(CartItem item) {
    final idx = _cartItems.indexOf(item);
    if (idx != -1 && _cartItems[idx].quantity > 1) {
      _cartItems[idx].quantity -= 1;
    }
  }

  static void increaseQuantity(CartItem item) {
    final idx = _cartItems.indexOf(item);
    if (idx != -1) {
      _cartItems[idx].quantity += 1;
    }
  }

  static void clearCart() {
    _cartItems.clear();
  }

  static String getFormattedTotalPrice() {
    double total = _cartItems.fold(0, (sum, item) => sum + item.food.price * item.quantity);
    return 'Rp ${total.toStringAsFixed(0)}';
  }
}
