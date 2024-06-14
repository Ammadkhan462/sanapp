import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sandapp/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        Get.snackbar('Success', 'Successfully signed in with Google');
        Get.offNamed(Routes.HOME);
      }
    } catch (e) {
      print('Google sign-in error: $e');
      Get.snackbar('Sign-in Error', e.toString());
    }
  }

  void pressed() async {
    await signInWithGoogle();
  }

  @override
  void onClose() {
    super.onClose();
    _googleSignIn.signOut();
    _auth.signOut();
  }
}
