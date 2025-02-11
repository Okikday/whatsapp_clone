import 'dart:developer';

import 'package:whatsapp_clone/data/drift_database/data/repos/chat_repository.dart';
import 'package:whatsapp_clone/data/drift_database/data/repos/message_repository.dart';

class AppData {
  /// Repository for chat-related operations.
  static final ChatRepository chats = ChatRepository();

  /// Repository for message-related operations.
  static final MessageRepository messages = MessageRepository();

  // /// Call this method once at app startup to initialize the underlying databases.
  // static Future<void> init() async {
  //   await chats.init();
  //   await messages.init();
  //   log("Successfully initialized AppData");
  // }
}
