class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final String category;
  final int stock; 

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock, 
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? 'No Name',
      description: data['description'] ?? '',
      price: data['price'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Uncategorized',
      stock: data['stock'] ?? 0, 
    );
  }

  // Fungsi untuk mengubah object menjadi Map, berguna untuk menambah data baru
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
    };
  }
}

