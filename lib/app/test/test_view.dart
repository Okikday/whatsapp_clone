// import 'package:flutter/material.dart';
//
// import '../../data/drift_database/data/repos/chat_repository.dart';
// import '../../data/drift_database/data/repos/message_repository.dart';
// import '../../models/chat_model.dart';
// import 'package:whatsapp_clone/models/message_model.dart';
//
// class TestView extends StatelessWidget {
//   const TestView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chat App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const ChatHomePage(),
//     );
//   }
// }
//
// /// The home page shows a list of chats and a form to create a new chat.
// class ChatHomePage extends StatefulWidget {
//   const ChatHomePage({Key? key}) : super(key: key);
//
//   @override
//   _ChatHomePageState createState() => _ChatHomePageState();
// }
//
// class _ChatHomePageState extends State<ChatHomePage> {
//   final ChatRepository chatRepo = ChatRepository();
//   final TextEditingController chatNameController = TextEditingController();
//   final TextEditingController contactIdController = TextEditingController();
//
//   @override
//   void dispose() {
//     chatNameController.dispose();
//     contactIdController.dispose();
//     super.dispose();
//   }
//
//   void _createChat() async {
//     if (chatNameController.text.trim().isEmpty ||
//         contactIdController.text.trim().isEmpty) {
//       return;
//     }
//     // Create a new ChatModel. For simplicity, we generate a unique chatId using UniqueKey.
//     final chat = ChatModel(
//       chatId: UniqueKey().toString(),
//       contactId: contactIdController.text,
//       chatName: chatNameController.text,
//       lastMsg: '',
//       lastUpdated: DateTime.now(),
//       // Other fields will take default values.
//     );
//     await chatRepo.addChat(chat);
//     chatNameController.clear();
//     contactIdController.clear();
//     // If using a Stream to watch chats, the UI will update automatically.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Chats")),
//       body: Column(
//         children: [
//           // Form to create a new chat.
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: chatNameController,
//                   decoration: const InputDecoration(
//                     labelText: "Chat Name",
//                     hintText: "Enter chat name",
//                   ),
//                 ),
//                 TextField(
//                   controller: contactIdController,
//                   decoration: const InputDecoration(
//                     labelText: "Contact ID / Phone",
//                     hintText: "Enter contact phone number or ID",
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: _createChat,
//                   child: const Text("Create Chat"),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           // List of chats (reactively updated via StreamBuilder)
//           Expanded(
//             child: StreamBuilder<List<ChatModel>>(
//               stream: chatRepo.watchAllChats(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No chats available"));
//                 }
//                 final chats = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: chats.length,
//                   itemBuilder: (context, index) {
//                     final chat = chats[index];
//                     return ListTile(
//                       title: Text(
//                         chat.chatName.isNotEmpty ? chat.chatName : chat.contactId,
//                       ),
//                       subtitle: Text("Last Msg: ${chat.lastMsg}"),
//                       onTap: () {
//                         // Navigate to the chat detail view when tapped.
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ChatDetailPage(chat: chat),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// The detail page for a specific chat. It shows the messages for that chat
// /// and provides a field to send new messages. Long-press a message to update it.
// class ChatDetailPage extends StatefulWidget {
//   final ChatModel chat;
//   const ChatDetailPage({Key? key, required this.chat}) : super(key: key);
//
//   @override
//   _ChatDetailPageState createState() => _ChatDetailPageState();
// }
//
// class _ChatDetailPageState extends State<ChatDetailPage> {
//   final MessageRepository messageRepo = MessageRepository();
//   final TextEditingController messageController = TextEditingController();
//
//   @override
//   void dispose() {
//     messageController.dispose();
//     super.dispose();
//   }
//
//   void _sendMessage() async {
//     final msgText = messageController.text;
//     if (msgText.trim().isEmpty) return;
//     final message = MessageModel(
//       messageId: UniqueKey().toString(),
//       chatId: widget.chat.chatId,
//       senderId: 'self', // For example, use "self" as the sender.
//       receiverId: widget.chat.contactId,
//       content: msgText,
//       mediaType: 0, // 0 indicates a text message.
//       sentAt: DateTime.now(),
//     );
//     await messageRepo.addMessage(message);
//     messageController.clear();
//   }
//
//   Future<void> _updateMessage(MessageModel message) async {
//     final newContent = await showDialog<String>(
//       context: context,
//       builder: (context) {
//         final updateController = TextEditingController(text: message.content);
//         return AlertDialog(
//           title: const Text("Update Message"),
//           content: TextField(
//             controller: updateController,
//             decoration: const InputDecoration(labelText: "New content"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, null),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, updateController.text),
//               child: const Text("Update"),
//             ),
//           ],
//         );
//       },
//     );
//     if (newContent != null && newContent.trim().isNotEmpty) {
//       final updatedMessage = MessageModel(
//         id: message.id,
//         messageId: message.messageId,
//         chatId: message.chatId,
//         senderId: message.senderId,
//         receiverId: message.receiverId,
//         content: newContent,
//         taggedMessageID: message.taggedMessageID,
//         mediaUrl: message.mediaUrl,
//         mediaType: message.mediaType,
//         sentAt: message.sentAt,
//         deliveredAt: message.deliveredAt,
//         readAt: message.readAt,
//         seenAt: message.seenAt,
//         isStarred: message.isStarred,
//         isDeleted: message.isDeleted,
//       );
//       await messageRepo.updateMessage(updatedMessage);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.chat.chatName.isNotEmpty ? widget.chat.chatName : widget.chat.contactId,
//         ),
//       ),
//       body: Column(
//         children: [
//           // Display messages for this chat
//           Expanded(
//             child: StreamBuilder<List<MessageModel>>(
//               stream: messageRepo.watchMessagesForChat(widget.chat.chatId),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No messages yet."));
//                 }
//                 final messages = snapshot.data!;
//                 return ListView.builder(
//                   reverse: true, // Latest messages at the bottom
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     return ListTile(
//                       title: Text(message.content),
//                       subtitle: Text(message.sentAt.toLocal().toString()),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () async {
//                           await messageRepo.deleteMessage(message.messageId);
//                         },
//                       ),
//                       onLongPress: () => _updateMessage(message),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           // Field to send a new message.
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: const InputDecoration(
//                       labelText: "Type a message",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _sendMessage,
//                   child: const Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
