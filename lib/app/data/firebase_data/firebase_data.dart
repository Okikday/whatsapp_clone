
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/app/data/user_data/user_data.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/features/authentication/use_cases/auth_functions.dart';

class FirebaseData {
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  Future<Result<UserCredentialModel>> createUserData(UserCredentialModel userCredentialModel) async {
    final Result userDataExists = await checkUserDataExists(userCredentialModel);
    if (userDataExists.isSuccess) {
      if (userDataExists.value == false) {
        try {
          await _collectionReference.doc(userCredentialModel.userID).set({...userCredentialModel.toMap(), "uniqueID": AuthFunctions.generateUserId()});
          return Result.success(userCredentialModel);
        } catch (e) {
          return Result.error("Unable to create user data in Firebase");
        }
      } else if (userDataExists.value == true) {
        try{
          final Result<UserCredentialModel> retrieveUserData = await getUserData(userCredentialModel.userID);
          if(retrieveUserData.isSuccess){
            return Result.success(retrieveUserData.value!);
          }else{
            return Result.error("Unable to retrieve user data: 1. ${retrieveUserData.error}");
          }
        }catch(e){
          return Result.error("User exists but unable to retrieve user information");
        }
      } else {
        return Result.error("Unable to create User Data");
      }
    }
    return Result.error("error retrieving user data");
  }

  Future<Result<UserCredentialModel>> getUserData(String userId) async {
    try {
      // Reference the user's document in Firestore
      DocumentReference userDocReference = _collectionReference.doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocReference.get();

      if (userDocSnapshot.exists) {
        // Extract the user data from the document snapshot
        Map<String, dynamic>? userData = userDocSnapshot.data() as Map<String, dynamic>?;

        if (userData == null || userData.isEmpty) return Result.error("Unable to fetch user data");
        return Result.success(UserCredentialModel.fromMap(userData));
      } else {
        return Result.error("User document does not exist!");
      }
    } catch (e) {
      return Result.error("An error occurred while fetching user data");
    }
  }

  Future<Result<bool>> checkUserDataExists(UserCredentialModel userCredentialModel) async {
    try {
      final DocumentSnapshot documentSnapshot = await _collectionReference.doc(userCredentialModel.userID).get();
      return Result.success(documentSnapshot.exists);
    } catch (e) {
      return Result.error("Unable to get user data");
    }
  }
}
