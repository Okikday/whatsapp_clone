// ignore_for_file: unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_clone/common/utilities.dart';
import 'package:whatsapp_clone/general/data/firebase_data/firebase_data.dart';
import 'package:whatsapp_clone/general/data/user_data/user_data.dart';

class UserAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
  final GoogleSignIn _googleAuth = GoogleSignIn(scopes: [
    'email',
    'profile',
    'openid',
  ]);
  String? message;
  final FirebaseData _firebaseData = FirebaseData();
  UserCredential? _userCredential;
  final UserDataFunctions userData = UserDataFunctions();

  Future<Result<bool>> signInWithGoogle() async {
    try {
      // Triggering the authentication flow
      final GoogleSignInAccount? googleUser = await _googleAuth.signIn();
      if (googleUser == null) {
        return Result.unavailable("Google Sign-In was canceled by the user.");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) return Result.error("Null user");
      
      final Result outcomeCreateUser = await _firebaseData.createUserData(UserCredentialModel(userID: user.uid, displayName: user.displayName ?? "Anonymous", email: user.email ?? "anonymous@gmail.com"));

      if (outcomeCreateUser.isSuccess) {
        userData.saveUserDetails(
          googleAccessToken: googleAuth.accessToken,
          googleIDToken: googleAuth.idToken,
          userCredentialModel: outcomeCreateUser.value);
        return Result.success(true);
      } else {

        return Result.unavailable("Unable to create User Data");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return Result.error("Account already exists with a different credential!");
      } else if (e.code == 'invalid-credential') {
        return Result.error("Invalid credentials!");
      } else {
        return Result.error("An unknown error occurred!");
      }
    } catch (e) {
      return Result.error("An error occurred during Google Sign-In");
    }
  }

  Future<Result<bool>> googleSignOut() async {
    try {
      await _googleAuth.signOut();
      await _firebaseAuth.signOut();
      userData.clearUserDetails();
      return Result.success(true);
    } catch (e) {
      return Result.error("Error: $e");
    }
  }
}
