import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whatsapp_clone/common/utilities.dart';
import 'package:whatsapp_clone/general/data/hive_data/hive_data.dart';

class UserDataFunctions {
  static const String _path = "user_data";

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static var data = HiveData.box;
  final hiveData = HiveData();

  Future<Result<bool>> saveUserDetails({String? googleIDToken, String? googleAccessToken, required UserCredentialModel userCredentialModel}) async {
    try {
      if (googleIDToken != null) await _secureStorage.write(key: "googleIDToken", value: googleIDToken);
      if (googleAccessToken != null) await _secureStorage.write(key: "googleAccessToken", value: googleAccessToken);

      userCredentialModel.toMap().forEach((key, value) async {
        if (value != null) await hiveData.setData(key: "$_path/$key", value: value);
      });

      return Result.success(true);
    } catch (e) {
      return Result.error("Error: $e");
    }
  }

  Future<Result<bool>> clearUserDetails() async {
    try {
      // Clear stored tokens and user information
      await _secureStorage.delete(key: 'googleIDToken');
      await _secureStorage.delete(key: 'googleAccessToken');
      UserCredentialModel.defaultMap.forEach((key, value) async {
        if (value != null) await hiveData.deleteData(key: "$_path/$key");
      });
      return Result.success(true);
    } catch (e) {
      return Result.error("Error: $e");
    }
  }

  Future<Result<UserCredentialModel>> getUserDetails() async {
    try {
      final Map<String, dynamic> userData = {};

      // Loop through default keys
      for (final key in UserCredentialModel.defaultMap.keys) {
        // Fetch data for each key
        userData[key] = await hiveData.getData(key: "$_path/$key");
      }

      // Create the UserCredentialModel from the fetched data
      final user = UserCredentialModel.fromMap(userData);
      return Result.success(user);
    } catch (e) {
      return Result.error("Failed to fetch user details: ${e.toString()}");
    }
  }

  Future<bool> isUserSignedIn() async => await hiveData.getData(key: "$_path/userID") != null;
}

// User credential model for easy User Object

class UserCredentialModel {
  final String userID;
  final String displayName;
  final String? userName;
  final String email;
  final String? photoURL;
  final bool isAnonymous;
  final bool? isEmailVerified;
  final String? phoneNumber;

  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const UserCredentialModel({
    required this.userID,
    required this.displayName,
    required this.email,
    this.userName,
    this.photoURL,
    this.isAnonymous = false,
    this.isEmailVerified,
    this.phoneNumber,
    this.creationTime,
    this.lastSignInTime,
  });

  factory UserCredentialModel.fromMap(Map<String, dynamic> map) {
    return UserCredentialModel(
      userID: map["userID"] as String,
      displayName: map["displayName"] as String,
      userName: map["userName"] as String? ?? map["displayName"] as String,
      email: map["email"] as String,
      photoURL: map["photoURL"] as String?,
      isAnonymous: map["isAnonymous"] as bool? ?? false,
      isEmailVerified: map["isEmailVerified"] as bool?,
      phoneNumber: map["phoneNumber"] as String?,
      creationTime: map["creationTime"] as DateTime?,
      lastSignInTime: map["lastSignInTime"] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'displayName': displayName,
      'userName': userName ?? displayName,
      'email': email,
      'photoURL': photoURL,
      'isAnonymous': isAnonymous,
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber,
      'creationTime': creationTime?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
    };
  }

  static const Map<String, dynamic> defaultMap = {
    'userID': null,
    'displayName': null,
    'userName': null,
    'email': null,
    'photoURL': null,
    'isAnonymous': null,
    'isEmailVerified': null,
    'phoneNumber': null,
    'creationTime': null,
    'lastSignInTime': null,
  };
}
