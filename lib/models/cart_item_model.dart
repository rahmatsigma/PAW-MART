import 'pet_food_model.dart';

class CartItem {
  final PetFoodModel food;
  int quantity;

  CartItem({required this.food, required this.quantity});
}
