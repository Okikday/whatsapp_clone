
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/utilities.dart';
import 'package:whatsapp_clone/general/data/user_data/user_data.dart';

class FirebaseData {
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  Future<Result<bool>> createUserData(UserCredentialModel userCredentialModel) async {
    try {
      await _collectionReference.doc(userCredentialModel.userID).set(userCredentialModel.toMap());
      return Result.success(true);
    } catch (e) {
      return Result.error("Unable to add user!");
    }
  }

  Future<Result<UserCredentialModel>> getUserData(String userId) async {
    try {

      // Reference the user's document in Firestore
      DocumentReference userDocReference = _collectionReference.doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocReference.get();

      if (userDocSnapshot.exists) {
        // Extract the user data from the document snapshot
        Map<String, dynamic>? userData = userDocSnapshot.data() as Map<String, dynamic>?;

        if (userData == null || userData.isEmpty) return Result.unavailable("Unable to fetch user data");
        return Result.success(UserCredentialModel.fromMap(userData));
      } else {
        return Result.unavailable("User document does not exist!");
      }
    } catch (e) {
      return Result.error("An error occurred while fetching user data");
    }
  }
}


