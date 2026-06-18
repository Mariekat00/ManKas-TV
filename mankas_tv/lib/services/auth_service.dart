import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart' show adminEmail;

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  bool get isAdmin => currentUser?.email?.toLowerCase() == adminEmail.toLowerCase();

  Future<void> signInWithGoogle() async {
    const webClientId = '451865698298-626fm5kgu56hd23tn9uphqd51u40l4j7.apps.googleusercontent.com';

    final googleSignIn = GoogleSignIn(serverClientId: webClientId);
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) throw Exception('Google sign-in was cancelled.');

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) throw Exception('No ID token from Google.');

    await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
