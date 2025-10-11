import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  // Fungsi helper untuk membuka URL (WhatsApp, Email, Telepon)
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Bantuan & Dukungan'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Pertanyaan Umum (FAQ)'),
          _buildFaqItem(
            'Bagaimana cara memesan produk?',
            'Anda bisa langsung menekan tombol "Beli" untuk checkout satu produk, atau tekan tombol "+Cart" untuk menambahkannya ke keranjang belanja. Setelah itu, buka keranjang belanja Anda untuk melanjutkan proses checkout beberapa produk sekaligus.',
          ),
          _buildFaqItem(
            'Metode pembayaran apa saja yang tersedia?',
            'Saat ini kami mendukung pembayaran di tempat (COD) dan pembayaran melalui QRIS yang akan ditampilkan setelah Anda membuat pesanan.',
          ),
          _buildFaqItem(
            'Berapa lama waktu pengiriman?',
            'Waktu pengiriman bervariasi tergantung lokasi Anda:\n- Pengiriman Reguler: 2-4 hari kerja.\n- Pengiriman Express: 1-2 hari kerja.',
          ),
          _buildFaqItem(
            'Bagaimana cara melacak pesanan saya?',
            'Anda dapat melihat status pesanan Anda di halaman "Riwayat Pesanan". Status akan berubah dari "Diproses" menjadi "Selesai" setelah Anda mengonfirmasi penerimaan barang.',
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Hubungi Kami'),
          _buildContactItem(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Live Chat (WhatsApp)',
            onTap: () {
              _launchURL('https://wa.me/6285738797430?text=Halo,%20saya%20butuh%20bantuan%20terkait%20aplikasi%20Paw%20Mart.');
            },
          ),
          _buildContactItem(
            context,
            icon: Icons.email_outlined,
            title: 'Email Dukungan',
            onTap: () {
              _launchURL('mailto:rahmattillah079@gmail.com?subject=Bantuan Aplikasi Paw Mart');
            },
          ),
          _buildContactItem(
            context,
            icon: Icons.phone_outlined,
            title: 'Call Center',
            onTap: () {
              _launchURL('tel:+6285738797430');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: const TextStyle(color: Colors.black54)),
          )
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
