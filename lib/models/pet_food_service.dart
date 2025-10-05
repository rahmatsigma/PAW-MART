import 'pet_food_model.dart';

class PetFoodService {
  static List<PetFoodModel> getAllPetFoods() {
    return [
      DogFood(
        id: 1,
        name: 'Royal Canin Adult Medium',
        brand: 'Royal Canin',
        category: 'Dry Food',
        price: 390000,
        imageUrl: 'assets/images/royalcaninmedium.png',
        description: 'Makanan anjing dewasa dengan nutrisi seimbang',
        weight: 2.0,
        stock: 25,
        ageGroup: 'adult',
        specialFeatures: ['Dental Care', 'Digestive Health'],
      ),
      CatFood(
        id: 2,
        name: 'Whiskas Adult Indoor',
        brand: 'Whiskas',
        category: 'Wet Food',
        price: 75000,
        imageUrl: 'assets/images/whiskas.png',
        description: 'Makanan kucing dewasa khusus indoor',
        weight: 0.4,
        stock: 50,
        isIndoor: true,
        lifestage: 'adult',
        healthBenefits: ['Hair Ball Control', 'Weight Management'],
      ),
      DogFood(
        id: 3,
        name: 'Pedigree Puppy',
        brand: 'Pedigree',
        category: 'Dry Food',
        price: 71000,
        imageUrl: 'assets/images/pedigree.png',
        description: 'Makanan anak anjing dengan DHA untuk perkembangan otak',
        weight: 1.5,
        stock: 30,
        ageGroup: 'puppy',
        specialFeatures: ['DHA', 'Calcium'],
      ),
      CatFood(
        id: 4,
        name: 'Pro Plan Kitten',
        brand: 'Pro Plan',
        category: 'Dry Food',
        price: 250000,
        imageUrl: 'assets/images/proplan.png',
        description: 'Makanan anak kucing dengan OptiStart',
        weight: 1.0,
        stock: 15,
        isIndoor: false,
        lifestage: 'kitten',
        healthBenefits: ['OptiStart', 'Immune Support'],
      ),
      PetFoodModel(
        id: 5,
        name: 'Versele Bird Food',
        brand: 'Versele-Laga',
        category: 'Seeds',
        price: 60000,
        imageUrl: 'assets/images/verselebird.jpeg',
        description: 'Makanan burung premium dengan biji-bijian pilihan',
        weight: 1.0,
        stock: 20,
        animalType: 'bird',
      ),
      DogFood(
        id: 6,
        name: 'Hill\'s Science Diet Senior',
        brand: 'Hill\'s',
        category: 'Dry Food',
        price: 790000,
        imageUrl: 'assets/images/hills.jpg',
        description: 'Makanan anjing senior dengan antioksidan',
        weight: 2.5,
        stock: 12,
        ageGroup: 'senior',
        specialFeatures: ['Antioxidants', 'Joint Support'],
      ),

      PetFoodModel(
        id: 7,
        name: 'TetraMin Tropical Flakes',
        brand: 'Tetra',
        category: 'Flakes',
        price: 55000,
        imageUrl: 'assets/images/tetramin.jpg', 
        description: 'Makanan ikan tropis harian dalam bentuk serpihan untuk meningkatkan warna dan vitalitas.',
        weight: 0.1, 
        stock: 40,
        animalType: 'fish',
      ),
      PetFoodModel(
        id: 8,
        name: 'Hikari Goldfish Gold',
        brand: 'Hikari',
        category: 'Pellets',
        price: 55000,
        imageUrl: 'assets/images/hikari.jpg', 
        description: 'Pelet premium mengapung untuk meningkatkan pertumbuhan dan warna pada ikan koki.',
        weight: 0.2, 
        stock: 22,
        animalType: 'fish',
      ),
      CatFood(
        id: 9,
        name: 'Royal Canin Indoor Adult',
        brand: 'Royal Canin',
        category: 'Wet Food',
        price: 310000,
        imageUrl: 'assets/images/royalcanin.png',
        description: 'Makanan kucing dewasa khusus indoor',
        weight: 0.4,
        stock: 50,
        isIndoor: true,
        lifestage: 'adult',
        healthBenefits: ['Hair Ball Control', 'Weight Management'],
      ),
    ];
  }

  static List<PetFoodModel> getPetFoodByAnimalType(String animalType) {
    return getAllPetFoods()
        .where((food) => food.animalType == animalType)
        .toList();
  }

  static List<PetFoodModel> getPetFoodByBrand(String brand) {
    return getAllPetFoods().where((food) => food.brand == brand).toList();
  }

  static List<PetFoodModel> searchPetFood(String query) {
    return getAllPetFoods()
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<PetFoodModel> getAvailablePetFood() {
    return getAllPetFoods().where((food) => food.isAvailable).toList();
  }
}