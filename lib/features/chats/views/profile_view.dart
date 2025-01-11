import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';

class ProfileView extends StatelessWidget {
  final bool isDarkMode;
  final double width;
  final double height;
  final ChatModel chatModel;
  const ProfileView({super.key, required this.isDarkMode, required this.height, required this.width, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.paddingOf(context).top + 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Hero(tag: "icon_arrow_back", child: BackButton()),
              Hero(
                tag: "profilePhoto",
                child: SizedBox(
                  width: width > height ? (width * 0.3) : (width * 0.35),
                  height: width > height ? (width * 0.3) : (width * 0.35),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: chatModel.chatProfilePhoto != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(chatModel.chatProfilePhoto!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              Hero(tag: "icon_more_vert", child: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)))
            ],
          ),
          const SizedBox(height: 16),
          CustomWidgets.text(context, chatModel.chatName, fontSize: 24, fontWeight: FontWeight.w500),
          CustomWidgets.text(context, chatModel.contactId,
              fontSize: 16, fontWeight: FontWeight.w500, color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.gray),
              const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProfileUtilButton(buttonWidth: width * 0.3, isDarkMode: isDarkMode, title: "Audio", iconString: IconStrings.callsIconOutlined),
              ProfileUtilButton(buttonWidth: width * 0.3, isDarkMode: isDarkMode, title: "Video", iconString: IconStrings.videoCallIcon),
              ProfileUtilButton(buttonWidth: width * 0.3, isDarkMode: isDarkMode, title: "Search", iconString: IconStrings.searchIconOutlined),
            ],
          )
        ],
      ),
    );
  }
}



class ProfileUtilButton extends StatelessWidget {
  final double buttonWidth;
  final bool isDarkMode;
  final String title;
  final String iconString;
  final void Function()? onTap;
  const ProfileUtilButton({super.key, required this.buttonWidth, required this.isDarkMode, required this.title, required this.iconString, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
                borderRadius: 12,
                backgroundColor: Colors.transparent,
                overlayColor: isDarkMode ? Colors.white10 : Colors.black12,
                pixelWidth: buttonWidth,
                pixelHeight: 72,
                side: BorderSide(color: isDarkMode ? WhatsAppColors.gray.withAlpha(60) : WhatsAppColors.battleshipGrey.withAlpha(60) ),
                onClick: () {
                  if(onTap != null) onTap!();
                },
                child: Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconString,
                      width: 26,
                      height: 26,
                      color: isDarkMode ? WhatsAppColors.accent : WhatsAppColors.primary,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                    CustomWidgets.text(context, title, fontWeight: FontWeight.w500)
                  ],
                ),
              );
  }
}