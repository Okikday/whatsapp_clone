import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../data/handle_ai_chat_store_data.dart';
import '../services/gemini_services.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  late final ChatMessagesController chatMessagesController;
  late final StreamSubscription<Content?> streamUserChatStore;
  final ChatUser user = ChatUser(id: "user");
  final ChatUser model = ChatUser(id: "model");
  final HandleAiChatStoreData handleAiChatStoreData = HandleAiChatStoreData("defaultUserId");
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    chatMessagesController = ChatMessagesController();
    streamUserChatStore = (handleAiChatStoreData.streamUserChatStoreContent()).listen((data) => listenToChatStore(data));
  }

  listenToChatStore(Content? content) {
    if (content == null) return;
    final ChatMessage chatMessage = ChatMessage(
      user: ChatUser(id: content.role ?? "none"),
      text: content.parts.firstOrNull is TextPart ? (content.parts.first as TextPart).text : "",
      createdAt: DateTime.now(),
    );
    chatMessagesController.addMessage(chatMessage);
  }

  Stream sendPromptToModel(Content content) async* {
    final List<Content> getUserChatContents = await handleAiChatStoreData.getUserChatStore();
    final Stream rawResult = GeminiServices.sendPrompt(content: [...getUserChatContents, content]);
    yield* rawResult;
  }

  @override
  void dispose() {
    chatMessagesController.dispose();
    streamUserChatStore.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: AiChatWidget(
              config: AiChatConfig(
                messageBuilder: (ChatMessage chatMessage){
                  return MarkdownBody(data: chatMessage.text, );
                },
                aiName: "Nurturely AI",
                scrollToBottomBuilder: (ScrollController scrollController) {
                  return SizedBox(height: 12);
                },
                welcomeMessageConfig: WelcomeMessageConfig(),
                exampleQuestions: [
                  ExampleQuestion(
                    question: "What's the best advice for a pregnant mother?",
                    config: ExampleQuestionConfig(
                      onTap: (value) {
                        if(isTyping) return;
                        final ChatMessage chatMessage = ChatMessage(user: ChatUser(id: "user"), text: value, createdAt: DateTime.now());
                        askModel(chatMessage);
                      },
                    ),
                  ),
                  ExampleQuestion(
                    question: "My baby is snoring whilst sleeping, What do I do?",
                    config: ExampleQuestionConfig(
                      onTap: (value) {
                        if(isTyping) return;
                        final ChatMessage chatMessage = ChatMessage(user: ChatUser(id: "user"), text: value, createdAt: DateTime.now());
                        askModel(chatMessage);
                      },
                    ),
                  ),
                ],
              ),

              currentUser: user,
              aiUser: model,
              controller: chatMessagesController,
              onSendMessage: (ChatMessage chatMessage) async {
                if(isTyping) return;
                askModel(chatMessage);
              },
            ),
          ),
        ),
      ),
    );
  }

  askModel(ChatMessage chatMessage) {
    // Add the user's message.
    chatMessagesController.addMessage(chatMessage);

    setState(() => isTyping = true);
    // Prepare a buffer to accumulate the AI's response.
    final StringBuffer modelResponseString = StringBuffer();

    // Insert an empty AI message into the chat and remember its index.
    chatMessagesController.addMessage(ChatMessage(user: ChatUser(id: "model"), text: "", createdAt: DateTime.now()));
    // Assuming chatMessagesController.messages returns the current list,
    // we get the last index where the message is from the model.
    final int aiMessageIndex = chatMessagesController.messages.lastIndexWhere((m) => m.user.id == "model");

    // Listen to the streaming AI response.
    final StreamSubscription modelResponseSub = sendPromptToModel(Content("user", [TextPart(chatMessage.text)])).listen((response) {
      final String? newText = response.text;
      if (newText != null) {
        // Append new text to the buffer.
        modelResponseString.write(newText);

        // Create a new ChatMessage with the updated text.
        final updatedMessage = ChatMessage(
          user: ChatUser(id: "model"),
          text: modelResponseString.toString(),
          createdAt: chatMessagesController.messages[aiMessageIndex].createdAt,
        );

        // Update the AI message at the stored index.
        chatMessagesController.updateMessage(updatedMessage);
      }
    });

    modelResponseSub.onError((a, b) {
      setState(() => isTyping = false);
    });
    // Clean up the subscription when done.
    modelResponseSub.onDone(() async {
      await modelResponseSub.cancel();
      setState(() => isTyping = false);
    });
  }
}
