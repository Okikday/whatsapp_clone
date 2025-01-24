
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/features/chats/views/select_contact_view.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/calls_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/chats_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/communities_tab_view.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/updates_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/widgets/chat_selection_app_bar_child.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';
import 'package:whatsapp_clone/features/home/views/widgets/home_app_bar_child.dart';
import 'package:whatsapp_clone/features/home/views/widgets/home_navigation_bar.dart';
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
        final double deviceHeight = appUiState.deviceHeight.value;
        final int homeBottomNavBarCurrentIndex = stateController.homeBottomNavBarCurrentIndex.value;
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
              bottomNavigationBar: HomeNavigationBar(homeBottomNavBarCurrentIndex: homeBottomNavBarCurrentIndex, isDarkMode: isDarkMode, scaffoldBgColor: scaffoldBgColor, stateController: stateController, pageController: pageController),
              floatingActionButton: Visibility(
                visible: homeBottomNavBarCurrentIndex != 2,
                child: FloatingActionButton(
                  onPressed: () {
                    navigator?.push(Utilities.customPageRouteBuilder(height: deviceHeight, child: const SelectContactView()));
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Icon(
                    homeBottomNavBarCurrentIndex == 0 ? Icons.add_comment_rounded : homeBottomNavBarCurrentIndex == 1 ? Icons.camera_alt : Icons.add_ic_call,
                    color: scaffoldBgColor,
                  ),
                ),
              ),
              body: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    if (value != homeBottomNavBarCurrentIndex) stateController.setHomeBottomNavBarCurrentIndex(value);
                  },
                  children: [
                    ChatsTabView(
                      chatModels: TestChatsData.chatList,
                    ).animate().scaleXY(begin: 0.99, end: 1, duration: const Duration(milliseconds: 150), curve: Curves.decelerate),
                    const UpdatesTabView().animate().fadeIn(begin: 0.8, duration: const Duration(milliseconds: 150), curve: Curves.decelerate),
                    const CommunitiesTabView().animate().fadeIn(begin: 0.8, duration: const Duration(milliseconds: 150), curve: Curves.decelerate),
                    const CallsTabView().animate().fadeIn(begin: 0.8, duration: const Duration(milliseconds: 150), curve: Curves.decelerate),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
