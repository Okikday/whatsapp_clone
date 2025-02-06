import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_animation_settings.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';
import 'package:whatsapp_clone/features/chats/views/sub_views/new_contact_view.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';
import 'package:whatsapp_clone/test_data_folder/test_data/test_chats_data.dart';

class SelectContactView extends StatelessWidget {
  const SelectContactView({super.key});

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
        appBar: CustomAppBarContainer(
            scaffoldBgColor: scaffoldBgColor,
            padding: EdgeInsets.zero,
            child: SelectContactAppBar(
              isDarkMode: isDarkMode,
            )),
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

              SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: TestChatsData.chatList.length, (context, index) {
                final ChatModel cacheChatModel = TestChatsData.chatList[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 21,
                    backgroundColor: WhatsAppColors.emerald,
                    backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: cacheChatModel.chatProfilePhoto),
                  ),
                  contentPadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 12),
                  title: CustomText(
                    cacheChatModel.chatName,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  subtitle: CustomText(
                    cacheChatModel.profileInfo,
                    fontSize: 12,
                    color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {},
                );
              }))
            ],
          ),
        ),
      ),
    );
  }
}

class SelectContactAppBar extends StatelessWidget {
  final bool isDarkMode;
  const SelectContactAppBar({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color getCurrIconColor = appUiState.isDarkMode.value ? Colors.white : Colors.black;
    return DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: WhatsAppColors.textSecondary.withValues(alpha: 0.1)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BackButton(
            color: getCurrIconColor,
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
              CustomText("${TestChatsData.chatList.length} contacts", fontSize: 12, fontWeight: FontWeight.w500),
            ],
          )),
          IconButton(
              onPressed: () {},
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
    );
  }
}
