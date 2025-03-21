import 'dart:async';
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
import 'package:whatsapp_clone/features/chats/controllers/select_contact_controller.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';
import 'package:whatsapp_clone/features/chats/views/new_contact_view.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';

class SelectContactView extends StatefulWidget {
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
  State<SelectContactView> createState() => _SelectContactViewState();
}

class _SelectContactViewState extends State<SelectContactView> {
  final SelectContactController selectContactController = SelectContactController();
  final ScrollController scrollbarController = ScrollController();
  late final StreamSubscription<EdgeInsets> viewInsetsSub;
  late final StreamSubscription<String> streamChatsTerm;
  StreamSubscription<List<ChatModel>>? chatStreamSub;

  @override
  void initState() {
    super.initState();
    viewInsetsSub = appUiState.viewInsets.listen((value) {
      // final bool isKeyboardVisible = value.bottom > 0.0;
      // final currentOffset = scrollbarController.offset;
      // if (isKeyboardVisible) {
      //   scrollbarController.animateTo(currentOffset + value.bottom/2, duration: Durations.medium1, curve: Curves.decelerate);
      // } else {
      //   scrollbarController.animateTo(currentOffset - value.bottom/2, duration: Durations.medium1, curve: Curves.decelerate);
      // }
    });
    streamChatsTerm = selectContactController.searchContactText.listen((value) {
      // Cancel any existing chat stream subscription.
      chatStreamSub?.cancel();

      if (value.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          selectContactController.streamedChatsFiltered.value = List.from([]);
        });

        return;
      }

      // Listen to the new stream for the current search term.
      chatStreamSub = AppData.chats.searchChatsStream(value).listen((chatList) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          selectContactController.streamedChatsFiltered.value = List.from(chatList);
        });
      });
    });
  }

  @override
  void dispose() {
    viewInsetsSub.cancel();
    streamChatsTerm.cancel();
    chatStreamSub?.cancel();
    scrollbarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
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
                        selectContactController: selectContactController,
                        isDarkMode: isDarkMode,
                        noOfContacts: noOfContacts.toString(),
                      );
                    })),
            body: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll(isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary),
              ),
              child: Scrollbar(
                  radius: const Radius.circular(12),
                  child: Obx(() {
                    final bool isSearchContactTextEmpty = selectContactController.searchContactText.isEmpty;
                    return CustomScrollView(
                      controller: scrollbarController,
                      slivers: [
                        // SPACING...
                        const SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),

                        if (selectContactController.isSearching.value)
                          SliverToBoxAdapter(
                            child: Center(
                              child: SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeCap: StrokeCap.round,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),

                        if (selectContactController.searchedChatModel.value != null)
                          _buildSearchContactTile(isDarkMode, selectContactController.searchedChatModel.value!,
                              selectContactController.searchContactText.value),

                        // SECTION: NEW GROUP, NEW CONTACT, NEW COMMUNITY.
                        SliverVisibility(visible: isSearchContactTextEmpty, sliver: _buildFirstSelectContactViewSection(isDarkMode)),

                        // SPACING...
                        SliverVisibility(
                          visible: isSearchContactTextEmpty,
                          sliver: SliverToBoxAdapter(child: ConstantSizing.columnSpacing(12)),
                        ),

                        // TITLE
                        SliverVisibility(
                          visible: selectContactController.streamedChatsFiltered.isNotEmpty || isSearchContactTextEmpty,
                          sliver: SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: CustomText(
                                "Contacts on WhatsApp",
                                color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        SliverVisibility(
                          visible: selectContactController.streamedChatsFiltered.isNotEmpty || isSearchContactTextEmpty,
                          sliver: SliverToBoxAdapter(child: ConstantSizing.columnSpacing(6)),
                        ),

                        SliverVisibility(
                          visible: selectContactController.streamedChatsFiltered.isNotEmpty || isSearchContactTextEmpty,
                          sliver: _buildContactsList(isDarkMode, selectContactController.streamedChatsFiltered),
                        ),

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

                        _buildMoreSection(isDarkMode),

                        SliverToBoxAdapter(child: ConstantSizing.columnSpacing(appUiState.viewInsets.value.bottom)),
                      ],
                    );
                  })),
            ),
          ),
        );
      },
    );
  }

  SliverList _buildMoreSection(bool isDarkMode) {
    return SliverList.builder(
      itemCount: SelectContactView.moreListData.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 21,
            backgroundColor: isDarkMode ? WhatsAppColors.arsenic : WhatsAppColors.taggedMsgReceived,
            child: Icon(
              SelectContactView.moreListData[index]["icon"],
              color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 12),
          title: CustomText(
            SelectContactView.moreListData[index]["title"],
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          onTap: SelectContactView.moreListData[index]["onPressed"],
        );
      },
    );
  }

  Widget _buildContactsList(bool isDarkMode, List<ChatModel> chatModels) {
    if (chatModels.isNotEmpty) {
      return SliverList.builder(
        itemCount: chatModels.length,
        itemBuilder: (context, index) {
          final cacheChatModel = chatModels[index];
          return ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: CircleAvatar(
                radius: 21,
                backgroundColor: WhatsAppColors.emerald,
                backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: cacheChatModel.chatProfilePhoto),
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
              final String? userId = AppData.userId;
              if (userId == null) return;

              navigator?.push(Utilities.customPageRouteBuilder(ChatView(
                chatModel: cacheChatModel,
                myUserId: userId,
              )));
            },
          );
        },
      );
    }

    return StreamBuilder(
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
                      backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: cacheChatModel.chatProfilePhoto),
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
                    final String? userId = AppData.userId;
                    if (userId == null) return;

                    navigator?.push(Utilities.customPageRouteBuilder(ChatView(
                      chatModel: cacheChatModel,
                      myUserId: userId,
                    )));
                  },
                );
              },
            );
          } else {
            return const SliverToBoxAdapter(child: SizedBox(height: 64, child: Center(child: CustomText("No contacts yet"))));
          }
        });
  }

  SliverToBoxAdapter _buildFirstSelectContactViewSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // New group
          ListTile(
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

          // New contact
          ListTile(
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

          // New community
          ListTile(
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
        ],
      ),
    );
  }
}

class SelectContactAppBar extends StatefulWidget {
  final SelectContactController selectContactController;
  final bool isDarkMode;
  final String noOfContacts;
  const SelectContactAppBar({
    super.key,
    required this.selectContactController,
    required this.isDarkMode,
    required this.noOfContacts,
  });

  @override
  State<SelectContactAppBar> createState() => _SelectContactAppBarState();
}

class _SelectContactAppBarState extends State<SelectContactAppBar> {
  late final FocusNode focusNode;
  late ValueNotifier<bool> isSearchBarVisible;
  Timer? searchTimer;
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
          return Obx(() {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (_, __) {
                if (this.isSearchBarVisible.value) {
                  this.isSearchBarVisible.value = false;
                  // widget.selectContactController.setSearchContactText('');
                } else {
                  Get.back();
                }
              },
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: isSearchBarVisible
                              ? BorderSide.none
                              : BorderSide(color: WhatsAppColors.textSecondary.withValues(alpha: 0.1)))),
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
                              onTapOutside: () {},
                              onchanged: (text) {
                                widget.selectContactController.setSearchContactText(text);
                                // Cancel the previous timer if it's still active.
                                if (searchTimer?.isActive ?? false) {
                                  searchTimer!.cancel();
                                }
                                // Schedule the search function to be called after 400ms.
                                searchTimer = Timer(const Duration(milliseconds: 300), () async {
                                  await widget.selectContactController.searchContactOnWhatsApp();
                                });
                              },
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
                            )),
                      )
                    ],
                  )),
            );
          });
        });
  }
}

Widget _buildSearchContactTile(bool isDarkMode, ChatModel cacheChatModel, String contactInput) {
  return SliverToBoxAdapter(
    child: ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: CircleAvatar(
          radius: 21,
          backgroundColor: WhatsAppColors.emerald,
          backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: cacheChatModel.chatProfilePhoto),
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
      trailing: CustomElevatedButton(
        onClick: () async {
          final String input = contactInput;
          Get.close(1);
          await addChatModelAsNumIfNotExist(cacheChatModel, input);
          final String? userId = AppData.userId;
          if (userId == null) return;

          navigator
              ?.push(Utilities.customPageRouteBuilder(ChatView(
            chatModel: cacheChatModel,
            myUserId: userId,
          )))
              .then((onValue) async {
            final Stream<List<MessageModel>> hasChatted = AppData.messages.watchMessagesForChat(cacheChatModel.chatId, limit: 1);
            hasChatted.listen((messages) async {
              if (messages.isNotEmpty) {
                return;
              } else {
                await AppData.chats.deleteChatWithMsgs(cacheChatModel.chatId);
              }
            });
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        backgroundColor: Theme.of(Get.context!).primaryColor,
        borderRadius: ConstantSizing.borderRadiusCircle,
        child: const CustomText(
          "Chat",
          color: Colors.white,
        ),
      ),
      onTap: () {},
    ),
  );
}

Future<void> addChatModelAsNumIfNotExist(ChatModel chatModel, String contactInput) async {
  log("contactInput: $contactInput");
  final ChatModel? getChat = await AppData.chats.getChatById(chatModel.chatId);
  if (getChat == null) {
    await AppData.chats.addChat(chatModel);
    return;
  } else {
    return;
  }
}
