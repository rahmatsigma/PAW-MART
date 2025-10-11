import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi Sign Up (tidak berubah)
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Langsung sign out setelah registrasi berhasil
      await _auth.signOut();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Error saat registrasi: ${e.message}");
      return null;
    }
  }

  // Fungsi Sign In (tidak berubah)
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

  // Fungsi Sign Out (tidak berubah)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Fungsi kirim email (tidak kita gunakan, tapi biarkan saja)
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Terjadi kesalahan";
    }
  }

  // --- FUNGSI BARU: UPDATE PASSWORD DI DALAM APLIKASI ---
  Future<String> updatePassword(String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return "Pengguna tidak ditemukan. Silakan login ulang.";
      }

      // 1. Buat kredensial dengan password saat ini untuk verifikasi
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // 2. Re-autentikasi pengguna untuk keamanan
      await user.reauthenticateWithCredential(credential);

      // 3. Jika berhasil, baru update passwordnya
      await user.updatePassword(newPassword);

      return "success";
    } on FirebaseAuthException catch (e) {
      // Tangani error umum dari Firebase
      if (e.code == 'wrong-password') {
        return "Password saat ini salah.";
      } else if (e.code == 'weak-password') {
        return "Password baru terlalu lemah (minimal 6 karakter).";
      }
      return e.message ?? "Terjadi kesalahan.";
    }
  }
}

