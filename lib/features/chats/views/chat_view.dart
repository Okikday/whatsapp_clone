
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/views/chat_msgs_view.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/chat_msg_box.dart';

final CustomNativeTextInputController nativeTextInputController = CustomNativeTextInputController();

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom.clamp(4.0, (Get.height / 1.9));

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBgColor, statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: scaffoldBgColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size(Get.width, 64),
          child: Container(
            color: scaffoldBgColor,
            width: Get.width,
            height: 64,
            margin: const EdgeInsets.only(top: kToolbarHeight - 26),
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                const BackButton(),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade500,
                  backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(child: CustomWidgets.text(context, "Someone", fontSize: Constants.fontSizeMedium, fontWeight: FontWeight.w500)),
                IconButton(onPressed: () {}, icon: Image.asset(IconStrings.videoCallIcon, width: 24, height: 24,)),
                IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      IconStrings.callsIconOutlined,
                      width: 24,
                      height: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                      colorBlendMode: BlendMode.srcIn,
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, size: 24, color: isDarkMode ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Chat background
              ChatMsgsView(isDarkMode: isDarkMode,),

              ChatMsgBox(keyboardHeight: keyboardHeight, isDarkMode: isDarkMode, scaffoldBgColor: scaffoldBgColor)
            ],
          ),
        ),
      ),
    );
  }
}
