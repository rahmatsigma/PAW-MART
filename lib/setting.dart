import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  String _getCurrentThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Mode Terang';
      case ThemeMode.dark:
        return 'Mode Gelap';
      case ThemeMode.system:
      default:
        return 'Sesuai Sistem';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 2,
      ),
      body: ListView(
        children: [
          _buildUserProfileSection(),
          const SizedBox(height: 8),
          Divider(color: Theme.of(context).dividerColor, thickness: 1),
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
            secondary: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('Notifikasi Push'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeThumbColor: Theme.of(context).primaryColor,
          ),
          _buildSettingsListTile(
            icon: Icons.palette_outlined,
            title: 'Tema',
            subtitle: _getCurrentThemeName(themeProvider.themeMode),
            onTap: () {
              _showThemeDialog(context, themeProvider);
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

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Tema'),
          children: <Widget>[
            RadioListTile<ThemeMode>(
              title: const Text('Mode Terang'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Mode Gelap'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sesuai Sistem'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      child: const Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
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
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
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
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
      title: Text(
        'Keluar',
        style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w500),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasi Keluar'),
              content: const Text('Apakah Anda yakin ingin keluar?'),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Batal',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Keluar',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
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