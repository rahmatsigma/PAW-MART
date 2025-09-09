import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  final String email;

  const BerandaPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    
    final items = [
      "Profile",
      "Pengaturan",
      "Notifikasi",
      "Pesan",
      "Bantuan",
      "Tentang Aplikasi"
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        title: const Text('Beranda'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selamat datang, $email 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.arrow_forward_ios, size: 20),
                    title: Text(items[index]),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kamu pilih: ${items[index]}")),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
