
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/calls_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/chats_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/communities_tab_view.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/updates_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/widgets/chat_selection_app_bar_child.dart';
import 'package:whatsapp_clone/features/home/views/widgets/home_app_bar_child.dart';
import 'package:whatsapp_clone/test_data_folder/test_data/test_chats_data.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    homeUiController.setHomeBottomNavBarCurrentIndex(0);
    homeUiController.sethomeCameraIconAnimController(AnimationController(vsync: this, duration: const Duration(milliseconds: 250)));
    pageController = PageController(initialPage: homeUiController.homeBottomNavBarCurrentIndex.value);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    WidgetsBinding.instance.addPostFrameCallback((_) => homeUiController.homeCameraIconAnimController.value!.forward(from: 0));

    return Obx(
      () {
        final HomeUiController stateController = homeUiController;
        final bool isDarkMode = appUiState.isDarkMode.value;
        return PopScope(
          canPop: stateController.canPop.value,
          onPopInvokedWithResult: (didPop, result) {
            if (chatsTabUiController.chatTilesSelected.isNotEmpty) chatsTabUiController.clearSelectedChatTiles();
          },
          child: AnnotatedRegion(
            value: SystemUiOverlayStyle(
                systemNavigationBarColor: scaffoldBgColor,
                statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
                statusBarColor: Colors.transparent),
            child: Scaffold(
              appBar: CustomAppBarContainer(
                  scaffoldBgColor: scaffoldBgColor,
                  padding: chatsTabUiController.chatTilesSelected.isEmpty ? null : EdgeInsets.zero,
                  child: chatsTabUiController.chatTilesSelected.isEmpty ? const HomeAppBarChild() : const ChatSelectionAppBarChild()),
              bottomNavigationBar: NavigationBar(
                selectedIndex: stateController.homeBottomNavBarCurrentIndex.value,
                indicatorColor: isDarkMode ? const Color(0xFF103629) : const Color(0xFFD8FDD2),
                overlayColor: WidgetStatePropertyAll(const Color(0xFF103629).withAlpha(26)),
                backgroundColor: scaffoldBgColor,
                onDestinationSelected: (value) {
                  if (value != stateController.homeBottomNavBarCurrentIndex.value) {
                    stateController.setHomeBottomNavBarCurrentIndex(value);
                    pageController.jumpToPage(
                      value,
                    );
                  }
                },
                destinations: [
                  NavigationDestination(
                    icon: Image.asset(
                      IconStrings.chatIconOutlined,
                      width: 24,
                      height: 24,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? null : WhatsAppColors.textPrimary,
                    ),
                    selectedIcon: Image.asset(
                      IconStrings.chatIconFilled,
                      width: 24,
                      height: 24,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? Colors.white : WhatsAppColors.accent,
                    ),
                    label: "Chats",
                    tooltip: "Chats",
                  ),
                  NavigationDestination(
                    icon: Image.asset(
                      IconStrings.updatesIconOutlined,
                      width: 24,
                      height: 24,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? null : WhatsAppColors.textPrimary,
                    ),
                    selectedIcon: Image.asset(
                      IconStrings.updatesIconFilled,
                      width: 24,
                      height: 24,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? null : WhatsAppColors.accent,
                    ),
                    label: "Updates",
                    tooltip: "Updates",
                  ),
                  NavigationDestination(
                    icon: Image.asset(
                      IconStrings.communitiesIconOutlined,
                      width: 28,
                      height: 28,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? null : WhatsAppColors.textPrimary,
                    ),
                    selectedIcon: Image.asset(
                      IconStrings.communitiesIconFilled,
                      width: 28,
                      height: 28,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? null : WhatsAppColors.accent,
                    ),
                    label: "Communities",
                    tooltip: "Communities",
                  ),
                  NavigationDestination(
                    icon: Image.asset(
                      IconStrings.callsIconOutlined,
                      width: 24,
                      height: 24,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? null : WhatsAppColors.textPrimary,
                    ),
                    selectedIcon: Image.asset(
                      IconStrings.callsIconFilled,
                      width: 24,
                      height: 24,
                      colorBlendMode: BlendMode.srcIn,
                      color: isDarkMode ? null : WhatsAppColors.accent,
                    ),
                    label: "Calls",
                    tooltip: "Calls",
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Icon(
                  FontAwesomeIcons.commentDots,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              body: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    if (value != stateController.homeBottomNavBarCurrentIndex.value) stateController.setHomeBottomNavBarCurrentIndex(value);
                  },
                  children: [
                    ChatsTabView(
                      chatModels: TestChatsData.chatList,
                    ),
                    const UpdatesTabView(),
                    const CommunitiesTabView(),
                    const CallsTabView(),
                  ]),
            ),
          ),
        );
      },
    );
  }
}

class CustomAppBarContainer extends StatelessWidget implements PreferredSizeWidget {
  final Color scaffoldBgColor;
  final EdgeInsets? padding;
  final Widget child;
  final double appBarHeight;
  const CustomAppBarContainer({super.key, required this.scaffoldBgColor, this.padding, required this.child, this.appBarHeight = 56});

  @override
  Size get preferredSize {
    return Size(appUiState.deviceWidth.value, appBarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final double width = appUiState.deviceWidth.value;
    final double height = appUiState.deviceHeight.value;
    final double topPadding = MediaQuery.paddingOf(context).top;
    return ColoredBox(
      color: scaffoldBgColor,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
            width: width,
            height: appBarHeight,
            child: Padding(
              padding: padding ?? EdgeInsets.only(left: width > height ? width * 0.05 : 16, right: width > height ? width * 0.05 : 0),
              child: child,
            )),
      ),
    );
  }
}
