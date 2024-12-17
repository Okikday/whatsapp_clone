import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/features/authentication/services/user_auth.dart';
import 'package:whatsapp_clone/features/calls/views/calls_tab_view.dart';
import 'package:whatsapp_clone/features/chats/views/chats_tab_view.dart';
import 'package:whatsapp_clone/features/communities/views/communities_tab_view.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';
import 'package:whatsapp_clone/features/updates/views/updates_tab_view.dart';
import 'package:whatsapp_clone/general/widgets/loading_dialog.dart';
import 'package:whatsapp_clone/routes_names.dart';

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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    WidgetsBinding.instance.addPostFrameCallback((_) => homeUiController.homeCameraIconAnimController.value!.forward(from: 0));

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBgColor,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(Get.width, 64),
          child: Container(
            color: scaffoldBgColor,
            width: Get.width,
            height: 64,
            margin: const EdgeInsets.only(top: kToolbarHeight - 24),
            padding: EdgeInsets.only(left: Get.width > Get.height ? Get.width * 0.05 : 16, right: Get.width > Get.height ? Get.width * 0.05 : 0),
            child: Row(
              children: [
                Obx(
                  () {
                    final int obxCurrentIndex = homeUiController.homeBottomNavBarCurrentIndex.value;
                    return CustomWidgets.text(context, AppConstants.homeTabTitles[obxCurrentIndex],
                        fontWeight: obxCurrentIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 24,
                        color: isDarkMode ? WhatsAppColors.background : (obxCurrentIndex == 0 ? WhatsAppColors.primary : Colors.black));
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Animate(
                      controller: homeUiController.homeCameraIconAnimController.value,
                      effects: const [MoveEffect(begin: Offset(24, 0), end: Offset(0, 0)), FadeEffect(begin: 0, end: 1, duration: Duration(milliseconds: 500))],
                      child: IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            IconStrings.cameraIconHome,
                            width: 24,
                            height: 24,
                            color: isDarkMode ? Colors.white : Colors.black,
                            colorBlendMode: BlendMode.srcIn,
                          )),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: homeUiController.homeBottomNavBarCurrentIndex.value == 1 || homeUiController.homeBottomNavBarCurrentIndex.value == 3,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            size: 24,
                            color: isDarkMode ? Colors.white : Colors.black,
                          )).animate().fadeIn(duration: const Duration(milliseconds: 150))),
                ),
                CustomPopupMenuButton(
                  menuItems: const ["Sign out"],
                  onSelected: (value) async {
                    if (value == "Sign out") {
                      Get.dialog(
                        const LoadingDialog(msg: "Signing out",),
                      );
                      Future.delayed(const Duration(seconds: 1), () async {
                        await UserAuth().googleSignOut();
                        Get.close(1);
                        Get.off(() => RoutesNames.welcomeScreen);
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => NavigationBar(
            selectedIndex: homeUiController.homeBottomNavBarCurrentIndex.value,
            indicatorColor: isDarkMode ? const Color(0xFF103629) : const Color(0xFFD8FDD2),
            overlayColor: WidgetStatePropertyAll(const Color(0xFF103629).withAlpha(26)),
            backgroundColor: scaffoldBgColor,
            onDestinationSelected: (value) {
              homeUiController.setHomeBottomNavBarCurrentIndex(value);
              pageController.jumpToPage(
                value,
              );
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
                  IconStrings.chatsIconFilled,
                  width: 24,
                  height: 24,
                  colorBlendMode: BlendMode.srcIn,
                  color: isDarkMode ? null : WhatsAppColors.accent,
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Icon(
            Icons.add_comment,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        body: PageView(
            controller: pageController,
            onPageChanged: (value) {
              homeUiController.setHomeBottomNavBarCurrentIndex(value);
            },
            children: const [
              ChatsTabView(),
              UpdatesTabView(),
              CommunitiesTabView(),
              CallsTabView(),
            ]),
      ),
    );
  }
}
