import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/app_exception.dart';

class AuthenticationRepo {
  final auth = FirebaseAuth.instance;

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String fname, String lname) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = FirebaseAuth.instance.currentUser!.uid.toString();
      final String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'password': hashed,
        "name": "$fname $lname"
      });
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthError(
          title: e.code,
          message: e.code == 'weak-password'
              ? "The password provided is too weak."
              : e.code == 'email-already-in-use'
                  ? "The account already exists for that email."
                  : e.message);
    } catch (e) {
      throw AppExceptionHandler.throwException(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          final DocumentReference userRef =
              firestore.collection('users').doc(user.uid);

          final DocumentSnapshot userDoc = await userRef.get();
          if (!userDoc.exists) {
            await userRef.set({
              'uid': user.uid,
              'email': user.email,
              "fname": user.displayName
            });
          }
        }
      }
    } on FirebaseException catch (e) {
      log("firebase error $e");
      throw FirebaseAuthError(title: e.code, message: e.message);
    } catch (e) {
      log("unidentify error $e");
      throw AppExceptionHandler.throwException(e);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.code);
      switch (e.code) {
        case 'invalid-credential':
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          throw AppException(
            title: "Invalid Credentials",
            message: "The email or password is incorrect. Please try again.",
          );
        default:
          throw AppException(
            title: e.code,
            message: e.message ?? "An unknown error occurred.",
          );
      }
    } catch (e) {
      throw AppExceptionHandler.throwException(e);
    }
  }
}
