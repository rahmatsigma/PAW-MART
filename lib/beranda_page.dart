import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:myapp/about.dart';
import 'package:myapp/cart_page.dart';
import 'package:myapp/order_history.dart';
import 'package:myapp/product_page.dart'; // <-- Menggunakan halaman produk yang baru
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/setting.dart';

class BerandaPage extends StatelessWidget {
  final String email;
  final AuthService _authService = AuthService();

  BerandaPage({super.key, required this.email});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _authService.signOut();
            },
            child: const Text('Iya'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Paw Mart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: _buildAppBarActions(context, isMobile),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context, isMobile),
            _buildCategorySection(context, isMobile),
          ],
        ),
      ),
    );
  }

  Drawer _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFF0F4F8)),
            child: Text('Menu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              }),
          ListTile(
            title: const Text('Shop'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductPage()));
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, bool isMobile) {
    final profileMenu = PopupMenuButton<String>(
      offset: const Offset(0, 40),
      icon: Icon(Icons.person_outline, color: Colors.grey[800]),
      onSelected: (value) {
        if (value == 'riwayat') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryPage()));
        } else if (value == 'pengaturan') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
        } else if (value == 'logout') {
          _showLogoutDialog(context);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: 'riwayat',
            child: ListTile(leading: Icon(Icons.history_outlined), title: Text('Riwayat Pesanan'))),
        const PopupMenuItem(
            value: 'pengaturan',
            child: ListTile(leading: Icon(Icons.settings_outlined), title: Text('Pengaturan'))),
        const PopupMenuDivider(),
        const PopupMenuItem(
            value: 'logout', child: ListTile(leading: Icon(Icons.logout), title: Text('Logout'))),
      ],
    );

    final cartButton = IconButton(
      icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey[800]),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
      },
    );

    if (isMobile) {
      return [cartButton, profileMenu];
    } else {
      return [
        NavTextButton(text: "Home", onPressed: () {}),
        const SizedBox(width: 15),
        NavTextButton(
          text: "Shop",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductPage())),
        ),
        const SizedBox(width: 15),
        NavTextButton(
          text: "About",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
        ),
        const SizedBox(width: 30),
        cartButton,
        const SizedBox(width: 10),
        profileMenu,
        const SizedBox(width: 20),
      ];
    }
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    // ... (kode hero section tidak berubah, aman)
    final textContent = Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 36 : 52,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              height: 1.2,
              fontFamily: 'Poppins',
            ),
            children: [
              const TextSpan(text: 'Premium Nutrition\nfor Your '),
              TextSpan(
                text: 'Furry Friends',
                style: TextStyle(color: Colors.blue.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Discover high-quality pet food that keeps your companions healthy and happy. Natural ingredients, scientifically formulated.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Shop Now', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Text('Learn More', style: TextStyle(fontSize: 16, color: Colors.black87)),
            ),
          ],
        ),
      ],
    );

    final imageContent = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/pawmart.png',
          fit: BoxFit.cover,
          height: isMobile ? 300 : 450,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).move(begin: const Offset(0, 50));

    return Container(
      color: const Color(0xFFF0F4F8),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 60, vertical: 40),
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang, ${email.split('@')[0]}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 40),
          isMobile
              ? Column(
                  children: [
                    textContent,
                    const SizedBox(height: 40),
                    imageContent,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: textContent),
                    const SizedBox(width: 60),
                    Expanded(child: imageContent),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, bool isMobile) {
    // ... (kode category section tidak berubah, aman)
    final categories = [
      {'icon': Icons.pets, 'label': 'Dog Food', 'category': 'Anjing'},
      {'icon': Icons.pets, 'label': 'Cat Food', 'category': 'Kucing'},
      {'icon': Icons.flutter_dash, 'label': 'Bird Food', 'category': 'Burung'},
      {'icon': Icons.water_drop_outlined, 'label': 'Fish Food', 'category': 'Ikan'},
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 24 : 60),
      child: Column(
        children: [
          const Text(
            'Shop by Category',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.5),
          const SizedBox(height: 16),
          const Text(
            'Find the perfect food for your pet’s needs',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.5),
          const SizedBox(height: 40),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              return CategoryCard(
                icon: cat['icon'] as IconData,
                label: cat['label'] as String,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(initialCategory: cat['category'] as String),
                    ),
                  );
                },
              );
            }).toList().animate(interval: 80.ms).fadeIn(duration: 400.ms).moveY(begin: 20),
          ),
        ],
      ),
    );
  }
}

// Helper widgets (aman)
class NavTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const NavTextButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      child: Text(text),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const CategoryCard({super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withAlpha(25),
              ),
              child: Icon(icon, color: Colors.blue.shade600, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

