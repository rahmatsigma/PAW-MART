import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/help_center.dart'; // <-- 1. IMPORT HALAMAN BANTUAN
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  // --- FUNGSI DIALOG YANG BARU DENGAN FORM ---
  void _showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        // Gunakan StatefulBuilder agar dialog bisa punya state sendiri (untuk loading)
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Ubah Password'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password Saat Ini'),
                      validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
                    ),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password Baru'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Tidak boleh kosong';
                        if (value.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru'),
                      validator: (value) {
                        if (value != newPasswordController.text) return 'Password tidak cocok';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      setDialogState(() => isLoading = true);
                      String result = await _authService.updatePassword(
                        currentPasswordController.text,
                        newPasswordController.text,
                      );
                      setDialogState(() => isLoading = false);

                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result == "success" ? 'Password berhasil diubah!' : result),
                            backgroundColor: result == "success" ? Colors.green : Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                      : const Text('Ubah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getCurrentThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Mode Terang';
      case ThemeMode.dark:
        return 'Mode Gelap';
      default:
        return 'Sesuai Sistem';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background, 
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
        elevation: 1,
      ),
      body: ListView(
        children: [
          _buildUserProfileSection(),
          const SizedBox(height: 8),
          _buildSettingsGroupTitle('Akun'),
          _buildSettingsListTile(
            icon: Icons.lock_outline,
            title: 'Ubah Password',
            onTap: _showChangePasswordDialog, // Panggil fungsi dialog yang baru
          ),
          _buildSettingsGroupTitle('Preferensi'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifikasi Push'),
            value: _notificationsEnabled,
            onChanged: (bool value) => setState(() => _notificationsEnabled = value),
          ),
          _buildSettingsListTile(
            icon: Icons.palette_outlined,
            title: 'Tema',
            subtitle: _getCurrentThemeName(themeProvider.themeMode),
            onTap: () => _showThemeDialog(context, themeProvider),
          ),
          _buildSettingsGroupTitle('Lainnya'),
          _buildSettingsListTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () {
              // Menampilkan dialog tentang aplikasi
              showAboutDialog(
                context: context,
                applicationName: 'Paw Mart',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Paw Mart',
              );
            },
          ),
          _buildSettingsListTile(
            icon: Icons.help_outline,
            title: 'Bantuan & Dukungan',
            onTap: () {
              // 2. NAVIGASIKAN KE HALAMAN BANTUAN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCenterPage()),
              );
            },
          ),
          const Divider(height: 20),
          _buildLogoutTile(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Sisa kode (tidak berubah)
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
                if (value != null) themeProvider.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Mode Gelap'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeProvider.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sesuai Sistem'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeProvider.setThemeMode(value);
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
      padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/images/riski.png'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser?.displayName ?? _currentUser?.email?.split('@')[0] ?? 'Pengguna',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _currentUser?.email ?? 'Tidak ada email',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.8,
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
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
  
  Widget _buildLogoutTile() {
    return ListTile(
      leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
      title: Text(
        'Keluar',
        style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) { 
            return AlertDialog(
              title: const Text('Konfirmasi Keluar'),
              content: const Text('Apakah Anda yakin ingin keluar?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () => Navigator.of(dialogContext).pop(), 
                ),
                TextButton(
                  child: Text('Keluar', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  onPressed: () {
                    _authService.signOut();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SplashScreen()),
                        (route) => false,
                      );
                    }
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

