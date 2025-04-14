import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/core/data/firebase_paths.dart';
import 'package:whatsapp_clone/core/services/connection_services.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/asymmetric_encryption.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/encryption_logic.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/encryption_service.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/features/chats/use_cases/chat_data_functions/chat_data_functions.dart';
import 'package:whatsapp_clone/models/asymmetric_encrypt_model.dart';
import 'package:whatsapp_clone/models/encrypt_model.dart';

class MessageServices {
  MessageServices._instance() {
    if (_myId.isEmpty) {
      // re-assign userId
      _myId = AppData.userId ?? "";
    }
    if (_myId.isEmpty) return;

    _load();
    log("Initialized Message Services");
  }

  static final MessageServices instance = MessageServices._instance();

  static String _myId = "";
  static final Set<String> _usersIdSet = {};
  static StreamSubscription? _otherUsersSub;

  Set<StreamSubscription> userMsgsSubSet = {};

  start() {
    log("Started Message Services");
  }

  _load() async {
    final bool isOnline = await ConnectionServices.instance.isDeviceOnline();

    if (!isOnline) return;

    log("Started listening for other users");
    _listenForOtherUsers();
  }

  void _listenForOtherUsers() {
    _otherUsersSub?.cancel();

    final CollectionReference otherUsersRef = FirebasePaths.otherUsersRef(_myId);
    _otherUsersSub = otherUsersRef.snapshots().listen((QuerySnapshot querySnapshot) {
      for (final QueryDocumentSnapshot event in querySnapshot.docs) {
        if (!event.exists) continue;
        _usersIdSet.add(event.id);
      }

      final Set<String> existingUserIds = querySnapshot.docs.map((doc) => doc.id).toSet();
      _usersIdSet.removeWhere((userId) => !existingUserIds.contains(userId));

      log("Messages from ${_usersIdSet.length} users");

      addToWatchList();
    });
    _otherUsersSub?.onDone(_listenForOtherUsers);
  }

  addToWatchList() {

    for (final String userId in _usersIdSet) {
      final CollectionReference receivedMsgsRef = FirebasePaths.otherUsersRef(_myId).doc(userId).collection("messages");
      final StreamSubscription _msgStreamSub = receivedMsgsRef.snapshots().listen((QuerySnapshot event) async {
        if (event.docs.isEmpty) return;
        for (final msgDoc in event.docs) {
          final dynamic data = msgDoc.data();
          if (data == null) continue;
          await _loadMsg(data);
        }
      });
      userMsgsSubSet.add(_msgStreamSub);
    }
  }

  Future<MessageModel?> _decryptMessage(MessageModel data) async {
    MessageModel message = data;
    final Map<String, dynamic>? metadata = message.metadata;
    if (metadata == null) return null;

    final String? symmetricPassword = await EncryptionService.instance
        .decryptSymmetricKey(metadata["encSymmetricPassword"], fallbackPublicKey: metadata["publicKeyUsed"]);
    if (symmetricPassword == null) return null;

    final Result<String> mediaUrl;
    final Result<String> content = SymmetricEncryption(symmetricPassword).decryptString(EncryptModel.fromJson(message.content));
    if (message.mediaUrl != null) {
      mediaUrl = SymmetricEncryption(symmetricPassword).decryptString(EncryptModel.fromJson(message.mediaUrl!));
    } else {
      mediaUrl = Result.unavailable(message.mediaUrl);
    }
    if (!content.isSuccess) return null;
    message = message.copyWith(
      content: content.value,
      mediaUrl: mediaUrl.isSuccess ? mediaUrl.value : null,
    );

    return message;
  }

  _loadMsg(dynamic data) async {
    try{
      if (data == null) return;
      final MessageModel? message = (await _decryptMessage(MessageModel.fromMap(Map<String, dynamic>.from(data as Map))));
      if (message == null) return;
      final ChatModel? checkUser = (await AppData.chats.getChatById(message.myId)); // myId in this case is the other user Id

      if (checkUser == null) {
        final UserCredentialModel userCredentialModel = UserCredentialModel.fromMap(
            Map<String, dynamic>.from(((await ChatFirebaseDataFunctions.firebasePublicInfoRef.doc(message.myId).get()).data()) as Map));
        if (userCredentialModel.phoneNumber == null) return;
        AppData.chats.addChat(ChatModel(
            chatId: userCredentialModel.userID, contactId: userCredentialModel.phoneNumber!, chatName: userCredentialModel.phoneNumber ?? "Unknown"));
      }

      if(await AppData.messages.doesMsgIdExists(message.messageId)){
        await AppData.messages.addMessage(message); // Edited message
        _deleteMsg(message.myId, message.messageId);
      }else{
        await AppData.messages.addMessage(message);
        await _deleteMsg(message.myId, message.messageId);
      }
    }catch(e){
      log("$e");
      log("Error @ MessageServices under _loadMsg");
    }
  }

  _deleteMsg(String userId, String msgId)async{
    try{
     await FirebasePaths.otherUsersRef(_myId).doc(userId).collection("messages").doc(msgId).delete();
    }catch(e){
      log("$e");
    }
  }
}
