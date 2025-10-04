// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart'; // <-- INI YANG HILANG DAN PALING PENTING
import 'models/pet_food_model.dart';
import 'models/pet_food_service.dart';
import 'models/cart_service.dart';
import 'pet_food_detail.dart';
import 'cart_page.dart';
import 'order_confirmation.dart';

class PetFood extends StatefulWidget {
  final String? initialCategory;

  const PetFood({super.key, this.initialCategory});

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

    if (widget.initialCategory != null) {
      String filterValue;
      switch (widget.initialCategory) {
        case 'Anjing':
          filterValue = 'dog';
          break;
        case 'Kucing':
          filterValue = 'cat';
          break;
        case 'Burung':
          filterValue = 'bird';
          break;
        case 'Ikan':
          filterValue = 'fish';
          break;
        default:
          filterValue = 'all';
      }
      selectedFilter = filterValue;
    }

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
      if (selectedFilter == 'all') {
        filteredPetFoodItems = petFoodItems;
      } else {
        filteredPetFoodItems = PetFoodService.getPetFoodByAnimalType(
          selectedFilter,
        );
      }
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
        filteredPetFoodItems = PetFoodService.getPetFoodByAnimalType(
          animalType,
        );
      }
      if (searchController.text.isNotEmpty) {
        filteredPetFoodItems = filteredPetFoodItems
            .where(
              (item) => item.name.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.blue[700],
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Shop',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search pet food...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  isDense: true,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterButton('all', 'All'),
                      _buildFilterButton('dog', 'Dogs'),
                      _buildFilterButton('cat', 'Cats'),
                      _buildFilterButton('bird', 'Birds'),
                      _buildFilterButton('fish', 'Fish'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredPetFoodItems.isEmpty
                ? const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredPetFoodItems.length,
                    itemBuilder: (context, index) {
                      final petFood = filteredPetFoodItems[index];
                      return _buildPetFoodCard(petFood, index);
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
      child: ElevatedButton(
        onPressed: () => _filterByAnimalType(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue[600] : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPetFoodCard(PetFoodModel petFood, int index) {
    bool isBestSeller = index % 5 == 0;
    bool isNew = index % 6 == 0 && !isBestSeller;

    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Area Gambar dan Nama Produk (digabung)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Produk
                  Image.network(
                    petFood.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(Icons.pets,
                            size: 50, color: Colors.grey.shade400),
                      );
                    },
                  ),

                  // Latar Belakang Gradien untuk Teks
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Nama Produk
                  Positioned(
                    bottom: 8,
                    left: 12,
                    right: 12,
                    child: Text(
                      petFood.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Badge
                  if (isBestSeller || isNew)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isBestSeller
                              ? Colors.orangeAccent
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isBestSeller ? 'Best Seller' : 'New',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Area Harga dan Tombol
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Harga
                  Flexible(
                    child: Text(
                      petFood.formattedPrice,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Tombol-tombol
                  Row(
                    children: [
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationPage(
                                  singleItem: petFood,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          child: const Text('Beli',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            CartService.addItemFromPetFood(petFood);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${petFood.name} ditambahkan ke keranjang'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'LIHAT',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CartPage()));
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          child: const Text('+ Add',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}