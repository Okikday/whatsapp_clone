import 'dart:developer';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/encryption_service.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/firebase_data/firebase_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/features/authentication/services/user_auth.dart';

class AuthFunctions {
  /// Generates a unique user ID.
  static String generateUserId() => const Uuid().v4();

  Future<Result> onGoogleSignIn({required String ngnPhoneNumber}) async {
    try {
      final Result<UserCredentialModel> result = await FirebaseGoogleAuth().signInWithGoogle(phoneNumber: ngnPhoneNumber);
      if (result.isSuccess != true) return Result.error(result.value.toString());
      final Result isNumberConflicting = await doesNumberConflict(ngnPhoneNumber, (result.value as UserCredentialModel).email);
      if (isNumberConflicting.isSuccess != true) return Result.error(isNumberConflicting.value.toString());
      log("doesNumberConflict: ${isNumberConflicting.value}");

      if (isNumberConflicting.value == false) {
        log("Creating existing phone number.....");
        AppData.userId = result.value!.userID;
        await createPublicInfo(result.value!);
        log("Successfully created existing phone number");
        final Result testStorage = await UserDataFunctions().getUserId();

        if (testStorage.isSuccess != true) return Result.error("Unable to access storage data...");
        if (AppData.userId != testStorage.value && (testStorage.value as String).isNotEmpty) AppData.userId = testStorage.value;
        return Result.success(true);
      } else {
        await FirebaseFirestore.instance.collection("users").doc(result.value?.userID).delete();
        return Result.unavailable("Phone number already exists with another email");
      }
    } catch (e) {
      return Result.error("Unknown error occurred while signing in.");
    }
  }

  Future<Result<bool>> doesNumberConflict(String ngnPhoneNumber, String email) async {
    try {
      final suppliedQuery = FirebaseFirestore.instance.collection("public_info");
      final Result userDataWithPN = await FirebaseData().getWhere(suppliedQuery: suppliedQuery, {"phoneNumber": ngnPhoneNumber});

      if (userDataWithPN.isSuccess != true) return Result.error("Unable to check if user's validity.");

      if (userDataWithPN.value == null) {
        return Result.success(false);
      }

      try {
        final Map<String, dynamic> userData = Map.from(userDataWithPN.value);

        if (userData['email'] == null) return Result.error("Error checking user's number and email alignment");
        if (userData['email'] != email) {
          return Result.success(true);
        } else {
          return Result.success(false);
        }
      } catch (e) {
        return Result.success(false);
      }
    } catch (e) {
      log("Error checking if number conflicts/exists: $e");
    }
    return Result.error("Error checking if number conflicts/exists");
  }

  Future<bool> createPublicInfo(UserCredentialModel userCredentialModel) async {
    try {
      final Map<String, dynamic> originalUserData = userCredentialModel.toMap();

      UserCredentialModel defaultUserData = UserCredentialModel.fromMap({
        'userID': originalUserData['userID'],
        'displayName': originalUserData['displayName'],
        'isAnonymous': originalUserData['isAnonymous'],
        'creationTime': originalUserData['creationTime'],
        'phoneNumber': originalUserData['phoneNumber'],
        'photoURL': originalUserData['photoURL'],
        'userName': originalUserData['userName'],
        'email': originalUserData['email'],
      });

      final CollectionReference ref = FirebaseFirestore.instance.collection("public_info");
      log("Creating Public info...");

      final bool resInitUser = await initUserOnFirebase(ref, userCredentialModel: defaultUserData);
      if (resInitUser != true) return false;
      log("Successfully created public info");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> initUserOnFirebase(CollectionReference ref, {required UserCredentialModel userCredentialModel}) async {
    try {
      RSAPublicKey? publicKey = await EncryptionService.instance.getPublicKeyAsync();
      if (publicKey == null) return false;
      final DocumentReference docRef = FirebaseFirestore.instance.collection("public_info").doc(userCredentialModel.userID);

      await docRef.update({
        ...(userCredentialModel.toMap()),
        'canReceiveChats': true,
        'contactId': userCredentialModel.phoneNumber,
        'publicKey': CryptoUtils.encodeRSAPublicKeyToPem(publicKey),
      });

      await FirebaseFirestore.instance.collection("chats").doc(userCredentialModel.userID).collection("users").doc("default").set({});
      return true;
    } catch (e) {
      log("Error @ initUserOnFirebase: $e");
      return false;
    }
  }
}
