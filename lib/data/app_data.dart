import 'dart:developer';

import 'package:get/get.dart';

import 'drift_database/data/repos/chat_repository.dart';
import 'drift_database/data/repos/message_repository.dart';

export 'package:whatsapp_clone/models/message_model.dart';
export 'package:whatsapp_clone/models/chat_model.dart';

class AppData extends GetxController{
  /// Repository for chat-related operations.
  static final ChatRepository chats = ChatRepository();

  /// Repository for message-related operations.
  static final MessageRepository messages = MessageRepository();

  static final Rx<String?> _userId = Rx<String?>(null);

  static String? get userId => _userId.value;
  static set userId(String? value) => _userId.value = value;

// /// Call this method once at app startup to initialize the underlying databases.
// static Future<void> init() async {
//   await chats.init();
//   await messages.init();
//   log("Successfully initialized AppData");
// }
}