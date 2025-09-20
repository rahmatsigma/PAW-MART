import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF6A55DF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildUserProfileSection(),

          const SizedBox(height: 10),
          const Divider(),

          // Grup Pengaturan Akun
          _buildSettingsGroupTitle('Akun'),
          _buildSettingsListTile(
            icon: Icons.person_outline,
            title: 'Ubah Profil',
            onTap: () {
              print('Navigasi ke halaman Ubah Profil');
            },
          ),
          _buildSettingsListTile(
            icon: Icons.lock_outline,
            title: 'Ubah Password',
            onTap: () {
              print('Navigasi ke halaman Ubah Password');
            },
          ),

          const Divider(),

          _buildSettingsGroupTitle('Preferensi'),
          SwitchListTile(
            secondary: const Icon(
              Icons.notifications_outlined,
              color: Colors.grey,
            ),
            title: const Text('Notifikasi Push'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeThumbColor: const Color(0xFF6A55DF),
          ),
          _buildSettingsListTile(
            icon: Icons.palette_outlined,
            title: 'Tema',
            subtitle: 'Mode Terang',
            onTap: () {
              print('Buka pilihan tema');
            },
          ),
          _buildSettingsListTile(
            icon: Icons.language_outlined,
            title: 'Bahasa',
            subtitle: 'Indonesia',
            onTap: () {
              print('Buka pilihan bahasa');
            },
          ),

          const Divider(),

          _buildSettingsGroupTitle('Lainnya'),
          _buildSettingsListTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () {
              print('Tampilkan info tentang aplikasi');
            },
          ),
          _buildSettingsListTile(
            icon: Icons.help_outline,
            title: 'Bantuan & Dukungan',
            onTap: () {
              print('Navigasi ke halaman bantuan');
            },
          ),

          const Divider(),

          _buildLogoutTile(),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF6A55DF).withOpacity(0.05),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=32',
            ), 
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riski Rahmattillah Pratama',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'riski@gmail.com', 
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF6A55DF),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSettingsListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Keluar', style: TextStyle(color: Colors.red)),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasi Keluar'),
              content: const Text('Apakah Anda yakin ingin keluar?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    print('Pengguna berhasil keluar');
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
