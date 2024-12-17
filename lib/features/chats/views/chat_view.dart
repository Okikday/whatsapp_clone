
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';
import 'package:whatsapp_clone/features/chats/controllers/chat_view_controller.dart';

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
              Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black.withAlpha(242) : WhatsAppColors.seaShell,
                    image: DecorationImage(
                      opacity: 0.8,
                        image: const AssetImage(
                          ImagesStrings.chatBackground,
                        ),
                        colorFilter: ColorFilter.mode(isDarkMode ? WhatsAppColors.gray : WhatsAppColors.linen, BlendMode.srcIn),
                        fit: BoxFit.fill)),
              ),

              Positioned(
                width: Get.width,
                bottom: keyboardHeight > 100 ? keyboardHeight + 4 : keyboardHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), offset: const Offset(0, 1), blurRadius: BlurEffect.neutralBlur, blurStyle: BlurStyle.inner)], borderRadius: BorderRadius.circular(24)),
                                height: currChatViewController.messageBarHeight.value,
                                child: CustomNativeTextInput(
                                  isEnabled: true,
                                  nativeTextInputController: nativeTextInputController,
                                  alignInput: Alignment.center,
                                  hint: "Message",
                                  hintStyle: TextStyle(color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic),
                                  backgroundColor: isDarkMode ? WhatsAppColors.arsenic : Colors.white,
                                  borderRadius: 24,
                                  cursorColor: WhatsAppColors.secondary,
                                  highlightColor: Colors.blue,
                                  onchanged: (text) {
                                    currChatViewController.setMessageInput(text);
                                  },
                                  contentPadding: currChatViewController.messageBarHeight > 48.0 ? const EdgeInsets.only(bottom: 2) : const EdgeInsets.only(top: 6, bottom: 2),
                                  internalArgs: (args) async{
                                    final lines = args.lines;
                                    if(lines != null){
                                      currChatViewController.checkMessageBarHeight(lines, padding: 16);
                                    }
                                  },
                                  inputTextStyle: TextStyle(color: CustomWidgets.text(context, "").style?.color, fontSize: 19),
                                  prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(IconStrings.stickersIcon, width: 24, height: 24, color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic, colorBlendMode: BlendMode.srcIn,),),
                                  suffixIcon: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: currChatViewController.messageInput.isEmpty ? 110 : 55,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: RotatedBox(
                                              quarterTurns: currChatViewController.messageInput.isEmpty ? 3 : 0,
                                              child: Icon(
                                                Icons.attachment,
                                                color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic,
                                              ),
                                            )),
                                        Visibility(
                                            visible: currChatViewController.messageInput.isEmpty ? true : false,
                                            child: Animate(
                                              effects: const [ScaleEffect(begin: Offset(0, 0), end: Offset(1, 1), duration: Duration(milliseconds: 200))],
                                              child: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic,
                                                  )),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTapDown: (details) => currChatViewController.setIsMicTappedDown(true),
                          onTapUp: (details) => currChatViewController.setIsMicTappedDown(false),
                          onTapCancel: () => currChatViewController.setIsMicTappedDown(false),
                          child: AnimatedScale(
                            scale: currChatViewController.messageInput.isEmpty ? currChatViewController.isMicTappedDown.value ? 1.25 : 1 : 1,
                            duration: const Duration(milliseconds: 100),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                              child: Icon(
                                currChatViewController.messageInput.isEmpty ? Icons.mic : Icons.send,
                                size: currChatViewController.messageInput.isEmpty ? 28 : 24,
                                color: scaffoldBgColor,
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
