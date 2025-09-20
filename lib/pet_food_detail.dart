import 'package:flutter/material.dart';
import 'models/pet_food_model.dart';

class PetFoodDetail extends StatelessWidget {
  final PetFoodModel petFood;

  const PetFoodDetail({super.key, required this.petFood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(petFood.name),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    petFood.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.pets, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),            
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Brand', petFood.brand),
                    _buildInfoRow('Kategori', petFood.category),
                    _buildInfoRow('Berat', petFood.formattedWeight),
                    _buildInfoRow('Harga', petFood.formattedPrice),
                    _buildInfoRow('Stok', '${petFood.stock} unit'),
                    _buildInfoRow(
                      'Untuk',
                      _capitalizeFirst(petFood.animalType),
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      petFood.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    
                    if (petFood is DogFood) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Kelompok Usia',
                        (petFood as DogFood).ageGroup,
                      ),
                      const Text(
                        'Fitur Khusus:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(petFood as DogFood).specialFeatures.map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 16),
                              const SizedBox(width: 8),
                              Text(feature),
                            ],
                          ),
                        ),
                      ),
                    ],
                    
                    if (petFood is CatFood) ...[
                      const Divider(height: 24),
                      _buildInfoRow('Tipe', (petFood as CatFood).indoorStatus),
                      _buildInfoRow(
                        'Tahap Hidup',
                        (petFood as CatFood).lifestage,
                      ),
                      const Text(
                        'Manfaat Kesehatan:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(petFood as CatFood).healthBenefits.map(
                        (benefit) => Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.favorite, size: 16),
                              const SizedBox(width: 8),
                              Text(benefit),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
