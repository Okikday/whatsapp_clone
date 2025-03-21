import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/features/authentication/use_cases/auth_functions.dart';

import '../user_data/user_data.dart';

/// A class to manage Firebase Firestore operations related to user data.
///
/// This class provides methods to create, retrieve, update, and delete user data,
/// as well as to listen for real-time changes on a user document.
class FirebaseData {
  /// Firestore collection reference for the 'users' collection.
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  /// Creates or retrieves user data in Firestore.
  ///
  /// The method first checks if the user data already exists.
  /// - If it doesn't exist, it creates a new document with the provided data
  ///   and a generated unique ID.
  /// - If it exists, it retrieves the existing data.
  ///
  /// Returns a [Result] containing a [UserCredentialModel] on success,
  /// or an error message on failure.
  Future<Result<UserCredentialModel>> createUserData(UserCredentialModel userCredentialModel) async {
    final Result userDataExists = await checkUserDataExists(userCredentialModel);
    if (userDataExists.isSuccess) {
      if (userDataExists.value == false) {
        try {
          await _collectionReference.doc(userCredentialModel.userID).set({
            ...userCredentialModel.toMap(),
            "uniqueID": AuthFunctions.generateUserId(),
          });
          return Result.success(userCredentialModel);
        } catch (e) {
          return Result.error("Unable to create user data in Firebase");
        }
      } else if (userDataExists.value == true) {
        try {
          final Result<UserCredentialModel> retrieveUserData = await getUserData(userCredentialModel.userID);
          if (retrieveUserData.isSuccess) {
            return Result.success(retrieveUserData.value!);
          } else {
            return Result.error("Unable to retrieve user data: ${retrieveUserData.error}");
          }
        } catch (e) {
          return Result.error("User exists but unable to retrieve user information");
        }
      } else {
        return Result.error("Unable to create User Data");
      }
    }
    return Result.error("Error retrieving user data");
  }

  /// Retrieves user data from Firestore for the given [userId].
  ///
  /// Returns a [Result] containing a [UserCredentialModel] on success,
  /// or an error message if the document does not exist or an error occurs.
  Future<Result<UserCredentialModel>> getUserData(String userId) async {
    try {
      DocumentReference userDocReference = _collectionReference.doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocReference.get();

      if (userDocSnapshot.exists) {
        Map<String, dynamic>? userData = userDocSnapshot.data() as Map<String, dynamic>?;
        if (userData == null || userData.isEmpty) {
          return Result.error("Unable to fetch user data");
        }
        return Result.success(UserCredentialModel.fromMap(userData));
      } else {
        return Result.error("User document does not exist!");
      }
    } catch (e) {
      return Result.error("An error occurred while fetching user data");
    }
  }

  /// Checks if user data exists in Firestore for the given [userCredentialModel].
  ///
  /// Returns a [Result] with a boolean indicating whether the document exists.
  Future<Result<bool>> checkUserDataExists(UserCredentialModel userCredentialModel) async {
    try {
      final DocumentSnapshot documentSnapshot = await _collectionReference.doc(userCredentialModel.userID).get();
      return Result.success(documentSnapshot.exists);
    } catch (e) {
      return Result.error("Unable to get user data");
    }
  }

  Future<Result<bool>> checkFieldInUsersExists(String fieldName, String value) async {
    try {
      final querySnapshot = await _collectionReference.where(fieldName, isEqualTo: value).get();
      return Result.success(querySnapshot.docs.isNotEmpty);
    } catch (e) {
      return Result.error("Error checking field existence: ${e.toString()}");
    }
  }


  Future<Result<UserCredentialModel?>> getUserWhere(Map<String, dynamic> filters, {Query? userQuery}) async {
    try {
      Query query = userQuery ?? _collectionReference;

      filters.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });

      final QuerySnapshot querySnapshot = await query.limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        return Result.success(null);
      }

      final DocumentSnapshot document = querySnapshot.docs.first;
      final Map<String, dynamic>? userData = document.data() as Map<String, dynamic>?;

      if (userData == null) {
        return Result.error("Invalid user data format");
      }

      return Result.success(UserCredentialModel.fromMap(userData));
    } catch (e) {
      return Result.error("Error retrieving user: ${e.toString()}");
    }
  }

  Future<Result<dynamic>> getWhere(
      Map<String, dynamic> filters, {
        Query? suppliedQuery,
      }) async {
    try {
      Query query = suppliedQuery ?? _collectionReference;

      // Apply each filter to the query.
      filters.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });

      final QuerySnapshot querySnapshot = await query.limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        return Result.success(null);
      }

      final DocumentSnapshot document = querySnapshot.docs.first;
      final dynamic data = document.data();

      return Result.success(data);
    } catch (e) {
      return Result.error("Error retrieving data: ${e.toString()}");
    }
  }

  Future<Result<List<dynamic>>> getAllWhere(
      Map<String, dynamic> filters, {
        Query? suppliedQuery,
      }) async {
    try {
      Query query = suppliedQuery ?? _collectionReference;

      // Apply each filter to the query.
      filters.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });

      // Retrieve all matching documents.
      final QuerySnapshot querySnapshot = await query.get();

      // If no documents match, return an empty list.
      if (querySnapshot.docs.isEmpty) {
        return Result.success([]);
      }

      // Extract the data from each document.
      final List<dynamic> allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      return Result.success(allData);
    } catch (e) {
      return Result.error("Error retrieving data: ${e.toString()}");
    }
  }


  Future<Result<bool>> deleteUserWhere(Map<String, dynamic> filters) async {
    try {
      Query query = _collectionReference;

      // Apply all filters to the query
      filters.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });

      QuerySnapshot querySnapshot = await query.get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return Result.success(true);
    } catch (e) {
      return Result.error("Failed to delete documents: ${e.toString()}");
    }
  }





  /// Updates the entire user data for the specified [userId] with [newData].
  ///
  /// This method performs a Firestore update operation on the user's document.
  /// After updating, it retrieves and returns the updated user data.
  ///
  /// Returns a [Result] containing a [UserCredentialModel] on success,
  /// or an error message on failure.
  Future<Result<UserCredentialModel>> updateUserData(String userId, Map<String, dynamic> newData) async {
    try {
      await _collectionReference.doc(userId).update(newData);
      return await getUserData(userId);
    } catch (e) {
      return Result.error("Failed to update user data: ${e.toString()}");
    }
  }

  /// Updates specific fields of the user data for the given [userId].
  ///
  /// [fieldsToUpdate] is a map containing only the fields that need to be updated.
  /// After updating, it retrieves and returns the updated user data.
  ///
  /// Returns a [Result] containing a [UserCredentialModel] on success,
  /// or an error message on failure.
  Future<Result<UserCredentialModel>> updateUserField(String userId, Map<String, dynamic> fieldsToUpdate) async {
    try {
      await _collectionReference.doc(userId).update(fieldsToUpdate);
      return await getUserData(userId);
    } catch (e) {
      return Result.error("Failed to update user field(s): ${e.toString()}");
    }
  }

  /// Deletes the user data from Firestore for the specified [userId].
  ///
  /// Returns a [Result] with a boolean value indicating success (true)
  /// or an error message on failure.
  Future<Result<bool>> deleteUserData(String userId) async {
    try {
      await _collectionReference.doc(userId).delete();
      return Result.success(true);
    } catch (e) {
      return Result.error("Failed to delete user data: ${e.toString()}");
    }
  }

  /// Returns a stream that emits changes to the user data for the given [userId].
  ///
  /// This method enables real-time listening for updates to the user's document.
  /// The stream emits a [Result] containing a [UserCredentialModel] when a change occurs,
  /// or an error message if the document is missing or data is invalid.
  Stream<Result<UserCredentialModel>> getUserDataStream(String userId) {
    try {
      return _collectionReference.doc(userId).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          final Map<String, dynamic>? userData = docSnapshot.data() as Map<String, dynamic>?;
          if (userData == null || userData.isEmpty) {
            return Result.error("User data is empty");
          } else {
            return Result.success(UserCredentialModel.fromMap(userData));
          }
        } else {
          return Result.error("User document does not exist");
        }
      });
    } catch (e) {
      return Stream.value(Result.error("Failed to listen for user data: ${e.toString()}"));
    }
  }
}