import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'beranda_page.dart';
import 'login.dart';

// Widget loading sederhana untuk AuthGate
class AuthGateLoader extends StatelessWidget {
  const AuthGateLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AuthGateLoader();
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            return BerandaPage(email: user.email ?? 'No Email');
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

