import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi Registrasi (Sign Up)
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // --- PERUBAHAN UTAMA ---
      // Langsung logout pengguna setelah akun berhasil dibuat.
      await _auth.signOut();
      // -----------------------

      // Kembalikan objek user untuk menandakan bahwa pembuatan akun berhasil.
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Anda bisa menambahkan penanganan error yang lebih spesifik di sini
      // jika diperlukan, misalnya dengan melempar (throw) error.
      print("Error saat registrasi: ${e.message}");
      return null;
    }
  }

  // Fungsi Login (Sign In)
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Error saat login: ${e.message}");
      return null;
    }
  }

  // Fungsi Logout (Sign Out)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

