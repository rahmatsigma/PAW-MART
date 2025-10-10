import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Menggunakan import relatif yang lebih aman
import 'firebase_options.dart';
import 'login.dart';
import 'beranda_page.dart';
import 'theme_provider.dart';
import 'splash_screen.dart'; // <-- 1. IMPORT SPLASH SCREEN ANDA

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'My App',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1BA0E2),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1BA0E2),
              foregroundColor: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1BA0E2),
              brightness: Brightness.dark,
            ),
          ),
          // 2. JADIKAN SPLASH SCREEN SEBAGAI HALAMAN UTAMA
          home: const SplashScreen(),
        );
      },
    );
  }
}

// 3. WIDGET SPLASH SCREEN INTERNAL DIHAPUS KARENA ANDA SUDAH PUNYA FILE SENDIRI

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Saat menunggu, cukup tampilkan loading indicator sederhana
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan koneksi."));
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            // Ini akan memanggil WIDGET BerandaPage yang sebenarnya
            return BerandaPage(email: user.email ?? 'No Email');
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

