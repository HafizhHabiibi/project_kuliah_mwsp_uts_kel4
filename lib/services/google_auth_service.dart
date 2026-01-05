import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  /// Login dengan Google + Firebase
  /// Return data user yang dibutuhkan backend
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // 🔥 FIX PENTING
      // Paksa logout dulu agar bisa pilih akun Google yang berbeda
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      // 1️⃣ Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Login Google dibatalkan');
      }

      // 2️⃣ Ambil token Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3️⃣ Credential Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // 4️⃣ Login Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Firebase user null');
      }

      // 5️⃣ Return data penting ke AuthService
      return {
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'provider': 'google',
        'provider_id': user.uid,
      };
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Logout Google (opsional, tapi best practice)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
