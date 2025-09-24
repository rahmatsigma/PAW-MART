  class PetFoodModel {
    final int id;
    final String name;
    final String brand;
    final String category;
    final double price;
    final String imageUrl;
    final String description;
    final double weight;
    final int stock;
    final String animalType;

    PetFoodModel({
      required this.id,
      required this.name,
      required this.brand,
      required this.category,
      required this.price,
      required this.imageUrl,
      required this.description,
      required this.weight,
      required this.stock,
      required this.animalType,
    });

    int get getId => id;
    String get getName => name;
    String get getBrand => brand;
    String get getCategory => category;
    double get getPrice => price;
    String get getImageUrl => imageUrl;
    String get getDescription => description;
    double get getWeight => weight;
    int get getStock => stock;
    String get getAnimalType => animalType;

    String get formattedPrice =>
        'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    bool get isAvailable => stock > 0;

    String get formattedWeight {
      if (weight < 1.0) {
        final grams = (weight * 1000).round();
        return '${grams}g';
      }
      return '${weight.toStringAsFixed(1)}kg';
    }

    @override
    String toString() {
      return 'PetFood{id: $id, name: $name, brand: $brand, category: $category, price: $price, weight: $weight, stock: $stock, animalType: $animalType}';
    }

    @override
    bool operator ==(Object other) {
      if (identical(this, other)) return true;
      return other is PetFoodModel && other.id == id;
    }

    @override
    int get hashCode => id.hashCode;

    factory PetFoodModel.fromJson(Map<String, dynamic> json) {
      return PetFoodModel(
        id: json['id'],
        name: json['name'],
        brand: json['brand'],
        category: json['category'],
        price: json['price'].toDouble(),
        imageUrl: json['imageUrl'],
        description: json['description'],
        weight: json['weight'].toDouble(),
        stock: json['stock'],
        animalType: json['animalType'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': name,
        'brand': brand,
        'category': category,
        'price': price,
        'imageUrl': imageUrl,
        'description': description,
        'weight': weight,
        'stock': stock,
        'animalType': animalType,
      };
    }

    PetFoodModel copyWith({
      int? id,
      String? name,
      String? brand,
      String? category,
      double? price,
      String? imageUrl,
      String? description,
      double? weight,
      int? stock,
      String? animalType,
    }) {
      return PetFoodModel(
        id: id ?? this.id,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        category: category ?? this.category,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        weight: weight ?? this.weight,
        stock: stock ?? this.stock,
        animalType: animalType ?? this.animalType,
      );
    }
  }

  class DogFood extends PetFoodModel {
    final String ageGroup;
    final List<String> specialFeatures;
    DogFood({
      required super.id,
      required super.name,
      required super.brand,
      required super.category,
      required super.price,
      required super.imageUrl,
      required super.description,
      required super.weight,
      required super.stock,
      required this.ageGroup,
      required this.specialFeatures,
    }) : super(
            animalType: 'dog',
          );

    String get getAgeGroup => ageGroup;
    List<String> get getSpecialFeatures => specialFeatures;

    @override
    String toString() {
      return 'DogFood{${super.toString()}, ageGroup: $ageGroup, specialFeatures: $specialFeatures}';
    }

    bool get isForPuppy => ageGroup.toLowerCase() == 'puppy';
    bool get hasSpecialFeatures => specialFeatures.isNotEmpty;
  }

  class CatFood extends PetFoodModel {
    final bool isIndoor;
    final String lifestage;
    final List<String> healthBenefits;

    CatFood({
      required super.id,
      required super.name,
      required super.brand,
      required super.category,
      required super.price,
      required super.imageUrl,
      required super.description,
      required super.weight,
      required super.stock,
      required this.isIndoor,
      required this.lifestage,
      required this.healthBenefits,
    }) : super(
            animalType: 'cat',
          );

    bool get getIsIndoor => isIndoor;
    String get getLifestage => lifestage;
    List<String> get getHealthBenefits => healthBenefits;

    @override
    String toString() {
      return 'CatFood{${super.toString()}, isIndoor: $isIndoor, lifestage: $lifestage, healthBenefits: $healthBenefits}';
    }

    String get indoorStatus => isIndoor ? 'Indoor Cat' : 'Outdoor Cat';
    bool get isForKitten => lifestage.toLowerCase() == 'kitten';
  }