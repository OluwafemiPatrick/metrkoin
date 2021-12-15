import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:metrkoin/screens/authentication/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices{

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User> get user {
    return _auth.authStateChanges();
  }


  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final User user = userCredential.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;

      assert(currentUser.uid == user.uid);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future<User> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final User user = userCredential.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;

      assert(currentUser.uid == user.uid);
      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      prefs.clear();

      await _auth.signOut();
      await _googleSignIn.signOut();
      Get.offAll(Wrapper());
      return true;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }


}