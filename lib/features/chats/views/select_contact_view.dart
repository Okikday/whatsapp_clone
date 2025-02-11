import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_animation_settings.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/drift_database/data/repos/chat_repository.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/features/chats/views/new_contact_view.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';
import 'package:whatsapp_clone/test_data_folder/test_data/test_chats_data.dart';

class SelectContactView extends StatelessWidget {
  const SelectContactView({super.key});
  static final List<Map<String, dynamic>> moreListData = [
    {
      "title": "New contact",
      "icon": Icons.person_add_alt,
      "onPressed": () {
        navigator?.push(Utilities.customPageRouteBuilder(const NewContactView()));
      }
    },
    {"title": "Share invite link", "icon": Icons.share_rounded, "onPressed": () {}},
    {"title": "Contacts help", "icon": Icons.question_mark_rounded, "onPressed": () {}},
  ];

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final bool isDarkMode = appUiState.isDarkMode.value;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBgColor,
          statusBarIconBrightness: appUiState.isDarkMode.value ? Brightness.light : Brightness.dark,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarContainer(
            scaffoldBgColor: scaffoldBgColor,
            padding: EdgeInsets.zero,
            child: StreamBuilder(
                stream: AppData.chats.streamChatCount(),
                builder: (context, snapshot) {
                  final noOfContacts = snapshot.hasData && snapshot.data != null ? snapshot.data! : "";
                  return SelectContactAppBar(
                    isDarkMode: isDarkMode,
                    noOfContacts: noOfContacts.toString(),
                  );
                })),
        body: RawScrollbar(
          thumbColor: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
          radius: const Radius.circular(12),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 8,
                ),
              ),
              // New group
              SliverToBoxAdapter(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 21,
                    backgroundColor: WhatsAppColors.emerald,
                    child: Icon(
                      Icons.people,
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 12),
                  title: const CustomText(
                    "New group",
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () {},
                ),
              ),

              // New contact
              SliverToBoxAdapter(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 21,
                    backgroundColor: WhatsAppColors.emerald,
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 48),
                  title: const CustomText(
                    "New contact",
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.qr_code,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  onTap: () {
                    navigator?.push(Utilities.customPageRouteBuilder(const NewContactView(),
                        curve: appAnimationSettingsController.curve,
                        transitionDuration: appAnimationSettingsController.transitionDuration,
                        reverseTransitionDuration: appAnimationSettingsController.reverseTransitionDuration));
                  },
                ),
              ),

              // New community
              SliverToBoxAdapter(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 21,
                    backgroundColor: WhatsAppColors.emerald,
                    child: Icon(
                      Icons.people,
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 12),
                  title: const CustomText(
                    "New community",
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () {},
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CustomText(
                    "Contacts on WhatsApp",
                    color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 6)),

              StreamBuilder(
                  stream: chatsTabUiController.tabChatsListStream.value,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && (snapshot.data != null && snapshot.data!.isNotEmpty)) {
                      return SliverList.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final cacheChatModel = snapshot.data![index];
                          return ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: CircleAvatar(
                                radius: 21,
                                backgroundColor: WhatsAppColors.emerald,
                                backgroundImage:
                                    Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: cacheChatModel.chatProfilePhoto),
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 12),
                            title: CustomText(
                              cacheChatModel.chatName,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            subtitle: cacheChatModel.profileInfo.isNotEmpty
                                ? CustomText(
                                    cacheChatModel.profileInfo,
                                    fontSize: 12,
                                    color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            onTap: () {
                              Get.close(1);
                              navigator?.push(Utilities.customPageRouteBuilder(ChatView(chatModel: cacheChatModel)));
                            },
                          );
                        },
                      );
                    } else {
                      return const SliverToBoxAdapter(child: SizedBox(height: 64, child: Center(child: CustomText("No contacts yet"))));
                    }
                  }),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CustomText(
                    "More",
                    color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 6)),

              SliverList.builder(
                itemCount: moreListData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 21,
                      backgroundColor: isDarkMode ? WhatsAppColors.arsenic : WhatsAppColors.taggedMsgReceived,
                      child: Icon(
                        moreListData[index]["icon"],
                        color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 12),
                    title: CustomText(
                      moreListData[index]["title"],
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: moreListData[index]["onPressed"],
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 6)),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectContactAppBar extends StatefulWidget {
  final bool isDarkMode;
  final String noOfContacts;
  const SelectContactAppBar({
    super.key,
    required this.isDarkMode,
    required this.noOfContacts,
  });

  @override
  State<SelectContactAppBar> createState() => _SelectContactAppBarState();
}

class _SelectContactAppBarState extends State<SelectContactAppBar> {
  late final FocusNode focusNode;
  late ValueNotifier<bool> isSearchBarVisible;
  @override
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    isSearchBarVisible = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    isSearchBarVisible.dispose();
    // focusNode is disposed automatically by custom text field
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color getCurrIconColor = appUiState.isDarkMode.value ? Colors.white : Colors.black;
    final Color primaryColor = Theme.of(context).primaryColor;

    return ValueListenableBuilder<bool>(
        valueListenable: isSearchBarVisible,
        builder: (context, isSearchBarVisible, child) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (_, __) => this.isSearchBarVisible.value ? this.isSearchBarVisible.value = false : Get.back(),
            child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            isSearchBarVisible ? BorderSide.none : BorderSide(color: WhatsAppColors.textSecondary.withValues(alpha: 0.1)))),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BackButton(
                          color: getCurrIconColor,
                        ).animate().fade(
                              begin: isSearchBarVisible ? 1.0 : 0.75,
                              end: isSearchBarVisible ? 0.1 : 1.0,
                            ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText("Select contact", fontSize: 15.5, fontWeight: FontWeight.w500),
                            Visibility(
                                visible: widget.noOfContacts.isNotEmpty,
                                child: CustomText("${widget.noOfContacts} contacts", fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        )),
                        IconButton(
                            onPressed: () {
                              this.isSearchBarVisible.value = true;
                              Future.delayed(Durations.medium1, () {
                                if (context.mounted) focusNode.requestFocus();
                              });
                            },
                            icon: Image.asset(
                              IconStrings.searchOutlined,
                              width: 24,
                              height: 24,
                              color: getCurrIconColor,
                              colorBlendMode: BlendMode.srcIn,
                            )),
                        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: getCurrIconColor))
                      ],
                    ),
                    AnimatedPositioned(
                      duration: Durations.medium1,
                      curve: appAnimationSettingsController.curve,
                      left: isSearchBarVisible ? 16 : appUiState.deviceWidth.value,
                      child: AnimatedOpacity(
                        opacity: isSearchBarVisible ? 1.0 : 0.0,
                        duration: isSearchBarVisible ? Durations.medium4 : appAnimationSettingsController.transitionDuration,
                        curve: appAnimationSettingsController.curve,
                        child: CustomTextfield(
                          selectionHandleColor: primaryColor,
                          selectionColor: primaryColor.withValues(alpha: 0.4),
                          focusNode: focusNode,
                          constraints: BoxConstraints(
                            minWidth: appUiState.deviceWidth.value - 32,
                            maxWidth: appUiState.deviceWidth.value - 32,
                          ),
                          maxLines: 1,
                          backgroundColor: widget.isDarkMode ? const Color(0xFF13181C) : WhatsAppColors.taggedMsgReceived,
                          pixelHeight: 56,
                          inputTextStyle: const CustomText("").effectiveStyle(context).copyWith(fontSize: 16),
                          cursorColor: primaryColor,
                          hint: "Search name or number",
                          hintStyle: const TextStyle(color: WhatsAppColors.battleshipGrey, fontWeight: FontWeight.w600),
                          prefixIcon: BackButton(
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                            onPressed: () async {
                              this.isSearchBarVisible.value = false;
                              Future.delayed(Durations.medium1, () {
                                if (context.mounted) focusNode.unfocus();
                              });
                            },
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              focusNode.hasFocus ? focusNode.unfocus() : focusNode.requestFocus();
                            },
                            icon: const Icon(Icons.keyboard),
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                          alwaysShowSuffixIcon: true,
                          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
