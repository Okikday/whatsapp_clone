import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';
import 'package:whatsapp_clone/features/chats/views/widgets/profile_list_tile.dart';

class ProfileView extends StatelessWidget {
  final ChatModel chatModel;
  ProfileView({super.key, required this.chatModel});

  final ValueNotifier<double> scrollOffsetNotifier = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final ScrollController scrollController = PrimaryScrollController.of(context);
    scrollController.addListener(() => scrollOffsetNotifier.value = scrollController.offset);
    log("Build profile view");

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Obx(
        () {
          final double width = appUiState.deviceWidth.value;
          final double leftPaddedWidth = width - 16;
          final double height = appUiState.deviceHeight.value;
          final bool isDarkMode = appUiState.isDarkMode.value;
          final Color altTextColor = isDarkMode ? WhatsAppColors.gray : WhatsAppColors.arsenic;
          final double statusBarHeight = MediaQuery.paddingOf(context).top;
          const double maxHeight = 135;
      
          final BoxDecoration boxDecoration = BoxDecoration(color: scaffoldBgColor, boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                color: isDarkMode ? Colors.black.withAlpha(50) : altTextColor.withAlpha(25),
                blurStyle: BlurStyle.solid,
                blurRadius: 2)
          ]);
          return SizedBox(
            height: height,
            width: width,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                SliverAppBar(
                  expandedHeight: maxHeight,
                  floating: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: ValueListenableBuilder<double>(
                    valueListenable: scrollOffsetNotifier,
                    builder: (context, value, child) {
                      final double reductionWidth = (value/maxHeight * (width/2));
                      log("$reductionWidth");
                      return FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(top: statusBarHeight),
                        expandedTitleScale: 1.0,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: innerBoxIsScrolled ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                          children: [
                            const Hero(tag: "icon_arrow_back", child: BackButton()),
                            if(!innerBoxIsScrolled && reductionWidth < 200) Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 350),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: reductionWidth),
                                    child: ProfilePhotoAvatar(url: chatModel.chatProfilePhoto, size: (125 - reductionWidth/(width/2) * 125).clamp(35, 125)),
                                  ),
                                ),
                              ),
                            ),
                            if(innerBoxIsScrolled || reductionWidth >= 200) AnimatedSize(
                              duration: const Duration(milliseconds: 350),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ProfilePhotoAvatar(url: chatModel.chatProfilePhoto, size: 35,),
                                ),
                            ),
                            const SizedBox(width: 8,),
                            if(innerBoxIsScrolled || reductionWidth >= 200) Expanded(child: Align(alignment: Alignment.centerLeft, child: CustomText(chatModel.chatName, fontSize: 20, fontWeight: FontWeight.w500,)).animate().slideX(begin: 0.1).fadeIn()),
                            Hero(tag: "icon_more_vert", child: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)))
                          ],
                        ),
                      );
                    }
                  ),
                )
              ];
              },
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Name
                  Center(
                    child: CustomWidgets.text(context, chatModel.chatName, fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  
                  // Phone number
                  Center(
                    child: CustomWidgets.text(context, chatModel.contactId,
                        fontSize: 16, fontWeight: FontWeight.w500, color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.gray),
                  ),
                  const SizedBox(height: 16),
                  DecoratedBox(
                    decoration: boxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ProfileUtilButton(buttonWidth: width * 0.3, title: "Audio", iconString: IconStrings.callsIconOutlined),
                          ProfileUtilButton(buttonWidth: width * 0.3, title: "Video", iconString: IconStrings.videoCallIcon),
                          ProfileUtilButton(buttonWidth: width * 0.3, title: "Search", iconString: IconStrings.searchIconOutlined),
                        ],
                      ),
                    ),
                  ),
                  
                  ColoredBox(
                      color: isDarkMode ? Colors.black : altTextColor.withAlpha(10),
                      child: SizedBox(
                        height: 8,
                        width: width,
                      )),
                  
                  // Profile Info
                  DecoratedBox(
                    decoration: boxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
                      child: SizedBox(
                        width: leftPaddedWidth,
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidgets.text(context, "About", fontWeight: FontWeight.w500, fontSize: 18),
                            CustomWidgets.text(context, "10 April, 2025", fontWeight: FontWeight.w500, color: altTextColor)
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  ColoredBox(
                      color: isDarkMode ? Colors.black : altTextColor.withAlpha(10),
                      child: SizedBox(
                        height: 8,
                        width: width,
                      )),
                  
                  // Media Links and docs
                  DecoratedBox(
                    decoration: boxDecoration,
                    child: SizedBox(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomElevatedButton(
                            backgroundColor: Colors.transparent,
                            borderRadius: 0,
                            onClick: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(child: CustomText("Media, links and docs", fontWeight: FontWeight.w500, color: altTextColor)),
                                  CustomText("10", color: altTextColor),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 12, color: altTextColor)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                                itemCount: 20,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: index == 0 ? 16 : 8),
                                    child: const ColoredBox(
                                        color: Colors.black,
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                        )),
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  ColoredBox(
                      color: isDarkMode ? Colors.black : altTextColor.withAlpha(10),
                      child: SizedBox(
                        height: 8,
                        width: width,
                      )),
                  
                  // Notifications and Media visibility
                  const Column(
                    children: [
                      ProfileListTile(
                          leading: Icon(
                            FontAwesomeIcons.bell,
                            size: 22,
                          ),
                          title: "Notifications"),
                      ProfileListTile(
                          leading: Icon(
                            FontAwesomeIcons.image,
                            size: 22,
                          ),
                          title: "Media Visibility")
                    ],
                  ),
                  
                  ColoredBox(
                      color: isDarkMode ? Colors.black : altTextColor.withAlpha(10),
                      child: SizedBox(
                        height: 8,
                        width: width,
                      )),
                  
                  DecoratedBox(
                    decoration: boxDecoration,
                    child: Column(
                      children: [
                        ProfileListTile(
                          leading: const Icon(
                            FontAwesomeIcons.lock,
                            size: 22,
                          ),
                          title: "Encryption",
                          subtitle: "Messages and calls will be end-to-end encrypted. Tap to verify",
                          subtitleColor: altTextColor,
                          trailing: const SizedBox(width: 24),
                        ),
                        ProfileListTile(
                          leading: const Icon(
                            FontAwesomeIcons.compass,
                            size: 22,
                          ),
                          title: "Disappearing Messages",
                          subtitle: "Off",
                          subtitleColor: altTextColor,
                        ),
                        ProfileListTile(
                          leading: const Icon(
                            FontAwesomeIcons.compass,
                            size: 22,
                          ),
                          title: "Chat lock",
                          subtitle: "Lock and hide this chat on this device",
                          subtitleColor: altTextColor,
                          trailing: Switch(value: false, onChanged: (value) {}),
                        ),
                      ],
                    ),
                  ),
                  
                  ColoredBox(
                      color: isDarkMode ? Colors.black : altTextColor.withAlpha(10),
                      child: SizedBox(
                        height: 8,
                        width: width,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfilePhotoAvatar extends StatelessWidget {
  const ProfilePhotoAvatar({
    super.key,
    required this.url,
    this.size = 45,
  });

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "profilePhoto",
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: url != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(url!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class ProfileUtilButton extends StatelessWidget {
  final double buttonWidth;
  final String title;
  final String iconString;
  final void Function()? onTap;
  const ProfileUtilButton({super.key, required this.buttonWidth, required this.title, required this.iconString, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isDarkMode = appUiState.isDarkMode.value;
        return CustomElevatedButton(
          borderRadius: 12,
          backgroundColor: Colors.transparent,
          overlayColor: isDarkMode ? Colors.white10 : Colors.black12,
          pixelWidth: buttonWidth,
          pixelHeight: 72,
          side: BorderSide(color: isDarkMode ? WhatsAppColors.gray.withAlpha(60) : WhatsAppColors.battleshipGrey.withAlpha(60)),
          onClick: () {
            if (onTap != null) onTap!();
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
      },
    );
  }
}
