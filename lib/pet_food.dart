import 'package:flutter/material.dart';
import 'models/pet_food_model.dart'; 
import 'models/pet_food_service.dart';
import 'pet_food_detail.dart';

class PetFood extends StatefulWidget {
  const PetFood({super.key});

  @override
  State<PetFood> createState() => _PetFoodListPageState();
}

class _PetFoodListPageState extends State<PetFood> {
  List<PetFoodModel> petFoodItems = [];
  List<PetFoodModel> filteredPetFoodItems = [];
  String selectedFilter = 'all';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPetFoods();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void loadPetFoods() {
    setState(() {
      petFoodItems = PetFoodService.getAllPetFoods();
      filteredPetFoodItems = petFoodItems;
    });
  }

  void _onSearchChanged() {
    String query = searchController.text;
    setState(() {
      if (query.isEmpty) {
        _filterByAnimalType(selectedFilter);
      } else {
        filteredPetFoodItems = PetFoodService.searchPetFood(query);
      }
    });
  }

  void _filterByAnimalType(String animalType) {
    setState(() {
      selectedFilter = animalType;
      if (animalType == 'all') {
        filteredPetFoodItems = petFoodItems;
      } else {
        filteredPetFoodItems = PetFoodService.getPetFoodByAnimalType(animalType);
      }
      if (searchController.text.isNotEmpty) {
        filteredPetFoodItems = filteredPetFoodItems.where((item) =>
            item.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Pet Food Store',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari makanan hewan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterButton('all', 'Semua'),
                _buildFilterButton('dog', 'Anjing'),
                _buildFilterButton('cat', 'Kucing'),
                _buildFilterButton('bird', 'Burung'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: filteredPetFoodItems.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada produk ditemukan',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPetFoodItems.length,
                    itemBuilder: (context, index) {
                      final petFood = filteredPetFoodItems[index];
                      return _buildPetFoodItem(petFood);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    bool isSelected = selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => _filterByAnimalType(value),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF2196F3).withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF2196F3) : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildPetFoodItem(PetFoodModel petFood) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, 
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetFoodDetail(petFood: petFood),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    petFood.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.pets, size: 40, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      petFood.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${petFood.brand} • ${petFood.formattedWeight}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      petFood.formattedPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}