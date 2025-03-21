import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/firebase_data/firebase_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';

class ChatFirebaseDataFunctions {
  static Future<Result<ChatModel>> getNumberOnWhatsApp(String ngnPhoneNumber) async {
    try {
      // is number on WhatsApp raw data form
      final Result isNumberOnWARaw = await FirebaseData()
          .getWhere(suppliedQuery: FirebaseFirestore.instance.collection("existingNumbers"), {"phoneNumber": ngnPhoneNumber});

      if (isNumberOnWARaw.isSuccess == false || isNumberOnWARaw.value == null) {
        return Result.error("Unable to get number or number doesn't exists");
      }

      final Map<String, dynamic> phoneDetails = Map.from(isNumberOnWARaw.value as Map<String, dynamic>);

      if (phoneDetails['email'] != null && (phoneDetails['email'] as String).isNotEmpty) {
        final Result<UserCredentialModel?> getUserDetails = await UserDataFunctions().getUserDetails();
        if (getUserDetails.isSuccess == false || getUserDetails.value == null) {
          return Result.error("Try logging in again. Error getting user's phone number");
        }

        final ChatModel chatModel = ChatModel(
          chatId: phoneDetails['userID'],
          chatName: phoneDetails['userName'],
          chatProfilePhoto: phoneDetails['photoURL'],
          contactId: phoneDetails['phoneNumber'],
          creationTime: DateTime.parse(phoneDetails['creationTime']),
        );

        if(chatModel.contactId == getUserDetails.value?.phoneNumber) return Result.success(chatModel.copyWith(chatName: "${chatModel.chatName} (You)"));
        return Result.success(chatModel);
      } else {
        return Result.unavailable("Number doesn't exists");
      }
    } catch (e) {
      return Result.error("An error occurred whilst checking if number is on WhatsApp Clone: checkNumberOnWhatsApp()");
    }
  }
}
