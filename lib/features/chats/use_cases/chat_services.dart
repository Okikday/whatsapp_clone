import 'dart:async';
import 'dart:developer';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/asymmetric_encryption.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/encryption_logic.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/features/chats/use_cases/functions/chats_functions.dart';
import 'package:whatsapp_clone/models/asymmetric_encrypt_model.dart';

class ChatServices {
  static final CollectionReference firebaseChatRef = FirebaseFirestore.instance.collection("chats");
  late StreamSubscription<DocumentSnapshot> _publicKeySubscription;
  String? _otherUserPublicKey;
  late String? _myId;
  late String _chatId;

  ChatServices(ChatModel chatModel) {
    _myId = AppData.userId;
    _chatId = chatModel.chatId;
    listenToPublicKey();
  }

  listenToPublicKey() {
    log("Started listening to publicKey on this Chat Service");

    _publicKeySubscription = firebaseChatRef.doc("$_chatId/publicKey").snapshots().listen(
      (snapshot) {
        final data = snapshot.data();
        if (data == null) return;
        final String dataToString = data as String;
        if (dataToString.isEmpty) return;
        _otherUserPublicKey = dataToString;
        log("Updated publicKey for this Chat Service");
      },
    );
  }

  void dispose() {
    _publicKeySubscription.cancel();
    log("Disposed Chat Service");
  }

  /// This contains all the function to successfully send a message
  Future<Result<bool>> sendMessage(
      {required String content, String? taggedMsgId, MessageType messageType = MessageType.text, String? mediaUrl}) async {
    final MessageModel? preparedMessage =
        await _prepareMessage(content: content, taggedMsgId: taggedMsgId, messageType: messageType, mediaUrl: mediaUrl);

    if (preparedMessage == null) return Result.error("Unable to Send message");

    await AppData.messages.addMessage(preparedMessage);

    if (_otherUserPublicKey == null) return Result.unavailable("Unable to access other user's public key");

    final MessageModel encryptedMessageModel = await _encryptMessage(preparedMessage);
    final Result<bool> sendMsgResult = await _sendMessageToFirebase(encryptedMessageModel: encryptedMessageModel);
    if(sendMsgResult.isSuccess != true) return Result.error("Unable to send message to firebase");
    await AppData.messages.updateMessage(preparedMessage.copyWith(sentAt: DateTime.now()));
    return Result.success(true);
  }

  /// This sends the message to firebase
  Future<Result<bool>> _sendMessageToFirebase({required MessageModel encryptedMessageModel}) async {
    try{
      final Map<String, dynamic> msgToSend = {
        ...encryptedMessageModel.toMap(),
        'timestamp': FieldValue.serverTimestamp()
      };
      if(_chatId.isEmpty || _myId == null || _myId!.isEmpty) return Result.error("chatId or _myId empty or null @ ChatServices");
      final DocumentReference docRef = firebaseChatRef.doc(_chatId).collection("messages").doc(_myId).collection("received").doc(encryptedMessageModel.messageId);
      await docRef.set(msgToSend);
      return Result.success(true);
    }catch(e){
      log("Unable to send message to firebase");
      return Result.error("Error sending message to firebase");
    }
  }

  /// This encrypts the message and prepares it for sending to firebase
  Future<MessageModel> _encryptMessage(MessageModel messageModel) async{
    MessageModel encryptedMessageModel;
    final String password = const Uuid().v4();

    final String encModelContent = SymmetricEncryption(password).encryptString(messageModel.content).toJson();

    if (messageModel.mediaUrl != null && messageModel.mediaUrl!.isNotEmpty) {
      final String encMediaUrlContent = SymmetricEncryption(password).encryptString(messageModel.mediaUrl!).toJson();
      encryptedMessageModel = messageModel.copyWith(content: encModelContent, mediaUrl: encMediaUrlContent);
    } else {
      encryptedMessageModel = messageModel.copyWith(content: encModelContent);
    }

    final String encSymmetricPassword = AsymmetricEncryption.asymmetricEncrypt(
        ToEncryptModel(data: password, publicKey: CryptoUtils.rsaPublicKeyFromPem(_otherUserPublicKey!)));

    encryptedMessageModel = encryptedMessageModel.copyWith(metadata: {
      'encSymmetricPassword': encSymmetricPassword,
      'publicKeyUsed': _otherUserPublicKey as String,
    });

    return encryptedMessageModel;
  }

  // Couples message to sendable format
  Future<MessageModel?> _prepareMessage(
      {required String content, String? taggedMsgId, MessageType messageType = MessageType.text, String? mediaUrl}) async {
    if (content.isEmpty) return null;
    final DateTime sentTime = DateTime.now();

    if (_myId == null || _myId!.isEmpty) {
      await tryLoadMyId();
      if (_myId == null || _myId!.isEmpty) return null;
    }
    // upload Media to Url if there is

    final String messageId = ChatsFunctions.generateMsgId();

    final MessageModel coupledMsgModel = MessageModel(
        messageId: messageId,
        chatId: _chatId,
        myId: _myId!,
        content: content,
        taggedMessageId: taggedMsgId,
        messageType: messageType,
        sentTime: sentTime,
        mediaUrl: mediaUrl);
    return coupledMsgModel;
  }

  /// This would try to load the id onto the memory again incase it can't find the userId
  Future<bool> tryLoadMyId() async {
    try {
      final Result<String> userIdRaw = await UserDataFunctions().getUserId();
      if (userIdRaw.isSuccess != true || userIdRaw.value == null || userIdRaw.value!.isEmpty) return false;
      AppData.userId = userIdRaw.value;
      _myId = userIdRaw.value;
      return true;
    } catch (e) {
      return false;
    }
  }


}
