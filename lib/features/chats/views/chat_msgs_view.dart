import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';

class ChatMsgsView extends StatelessWidget {
  final bool isDarkMode;
  const ChatMsgsView({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
