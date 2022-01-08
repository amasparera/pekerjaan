import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

class AuthUser {
  void signInWithGoogle() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication?.idToken,
          accessToken: googleSignInAuthentication?.accessToken);

      UserCredential result = await _auth.signInWithCredential(authCredential);

      User? user = result.user;

      if (user != null) {
        Myuser().saveUserEmail(user.email);
        Myuser().saveUserId(user.uid);
        Myuser().saveDisplayName(user.displayName);
        Myuser().saveUserProfile(user.photoURL);
        Myuser().saveUserName(user.email!.replaceAll('@gmail.com', ''));

        Map<String, dynamic> userData = {
          'email': user.email,
          'name': user.displayName,
          'userid': user.uid,
          'profileUrl': user.photoURL,
          'username': user.email!.replaceAll('@gmail.com', '')
        };

        FirebaseFirestroreku()
            .addUserInfoToDb(user.uid, userData)
            .then((value) => Get.offAndToNamed(Routes.HOME));
      } else {
        // ignore: avoid_print
        return print('failed');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    GetStorage box = GetStorage();
    box.erase();
    await _auth.signOut().then((value) => Get.offAllNamed(Routes.LOGIN));
  }
}
