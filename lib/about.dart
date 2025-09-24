import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: const Color(0xFF2196F3), // Warna yang konsisten
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppInfoCard(context),
            const SizedBox(height: 24),
            _buildDeveloperProfileCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🐾 Tentang Paw Mart',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const Divider(height: 24),
            const Text(
              'Paw-Mart adalah tempatnya pecinta hewan buat cari makanan dan kebutuhan terbaik untuk si kesayangan. Kami tahu banget kalau hewan peliharaan itu bukan sekadar hewan, tapi keluarga yang selalu bikin hari lebih ceria. Karena itu, kami menghadirkan berbagai pilihan makanan hewan yang sehat, bergizi, dan tentunya bikin mereka tetap aktif dan bahagia. Di Paw-Mart, kamu bisa nemuin makanan untuk kucing, anjing, dan hewan peliharaan lainnya dengan banyak variasi rasa dan merek. Harganya juga ramah di kantong, jadi nggak perlu khawatir dompet jebol. Selain itu, belanja di sini gampang banget, tinggal pilih produk favorit, masukkan ke keranjang, dan tunggu sampai sampai di rumah. Kami percaya, hewan yang sehat = pemilik yang bahagia. Jadi, biarin Paw-Mart jadi partner kamu dalam merawat si bulu kesayangan. Yuk, bikin mereka lebih happy bareng Paw-Mart! 🐶🐱',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Misi kami adalah menyediakan akses mudah ke berbagai produk berkualitas tinggi, mulai dari makanan bernutrisi, mainan, hingga aksesoris, yang semuanya berasal dari brand terpercaya. Dengan antarmuka yang ramah pengguna, kami berharap dapat membuat pengalaman merawat hewan peliharaan menjadi lebih mudah dan menyenangkan.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperProfileCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Riski Rahmattilah Pratama', 
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mahasiswa', 
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '24111814079 • S1 Informatika', 
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            Text(
              'Surabaya State University', 
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const Divider(height: 32),
            const Text(
              'Seorang individu yang bersemangat dalam dunia teknologi dan pengembangan perangkat lunak, dengan ketertarikan khusus pada pengembangan aplikasi mobile menggunakan Flutter. Aplikasi ini adalah wujud dari keinginan untuk menciptakan solusi digital yang bermanfaat dan kecintaan terhadap hewan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  Icons.link,
                  () => _launchURL('https://www.linkedin.com/in/username/'),
                ),
                _buildSocialButton(
                  Icons.code,
                  () => _launchURL('https://github.com/username'),
                ),
                _buildSocialButton(
                  Icons.camera_alt,
                  () => _launchURL('https://www.instagram.com/username/'),
                ),
                _buildSocialButton(
                  Icons.email,
                  () => _launchURL('mailto:emailanda@example.com'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 28,
      color: const Color(0xFF2196F3),
    );
  }
}
