import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';

class MsgBubbleFunctions {
  final ChatViewController _chatViewController;

  MsgBubbleFunctions(ChatViewController chatViewController) : _chatViewController = chatViewController;

  void onLongPress(int index) {
    final Map<int, int?> chatsBubbleSelected = _chatViewController.chatsSelected;

    if (chatsBubbleSelected[index] != null) {
      _chatViewController.removeSelectedChatBubble(index);
    } else {
      _chatViewController.selectChatBubble(index);
    }
  }

  void onTapBubble(int index) {
    final Map<int, int?> chatsBubbleSelected = _chatViewController.chatsSelected;
    if (chatsBubbleSelected.isEmpty) {
    } else {
      if (chatsBubbleSelected[index] != null) {
        _chatViewController.removeSelectedChatBubble(index);
      } else {
        _chatViewController.selectChatBubble(index);
      }
    }
  }

  void onTapTaggedMsg(int index) {
    final Map<int, int?> chatsBubbleSelected = _chatViewController.chatsSelected;
    if (chatsBubbleSelected.isEmpty) {
    } else {
      if (chatsBubbleSelected[index] != null) {
        _chatViewController.removeSelectedChatBubble(index);
      } else {
        _chatViewController.selectChatBubble(index);
      }
    }
  }
}

