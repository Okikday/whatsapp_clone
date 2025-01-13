
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/features/authentication/services/user_auth.dart';
import 'package:whatsapp_clone/features/authentication/views/welcome_screen.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/calls_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/chats_tab_view.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/communities_tab_view.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';
import 'package:whatsapp_clone/features/home/views/tab_views/updates_tab_view.dart';
import 'package:whatsapp_clone/test_data_folder/test_data/test_chats_data.dart';
import 'package:whatsapp_clone/common/widgets/loading_dialog.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_){
      homeUiController.updateHomeAppBar(context: context);
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeUiController.updateHomeAppBar(context: context);
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
            stateController.clearSelectedChatTiles();
          },
          child: AnnotatedRegion(
            value: SystemUiOverlayStyle(
                systemNavigationBarColor: scaffoldBgColor,
                statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
                statusBarColor: Colors.transparent),
            child: Scaffold(
              appBar: stateController.currHomeAppBar.value,
              bottomNavigationBar: NavigationBar(
                selectedIndex: stateController.homeBottomNavBarCurrentIndex.value,
                indicatorColor: isDarkMode ? const Color(0xFF103629) : const Color(0xFFD8FDD2),
                overlayColor: WidgetStatePropertyAll(const Color(0xFF103629).withAlpha(26)),
                backgroundColor: scaffoldBgColor,
                onDestinationSelected: (value) {
                  stateController.setHomeBottomNavBarCurrentIndex(value);
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
                    stateController.setHomeBottomNavBarCurrentIndex(value);
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

customAppBar(BuildContext context, {required Color scaffoldBgColor, EdgeInsets? padding, required Widget child}) {
  final double topPadding = MediaQuery.paddingOf(Get.context ?? context).top;
  final double width = MediaQuery.sizeOf(Get.context ?? context).width;
  final double height = MediaQuery.sizeOf(Get.context ?? context).height;
  return PreferredSize(
    preferredSize: Size(width, 56),
    child: Container(
        color: scaffoldBgColor,
        width: width,
        height: 64,
        margin: EdgeInsets.only(top: topPadding),
        padding: padding ?? EdgeInsets.only(left: width > height ? width * 0.05 : 16, right: width > height ? width * 0.05 : 0),
        child: child),
  );
}

class NormalAppBarChild extends StatelessWidget {
  const NormalAppBarChild({super.key,});
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Obx(
      () {
        final HomeUiController stateController = homeUiController;
        final int stateCurrentIndex = stateController.homeBottomNavBarCurrentIndex.value;
        return Row(
          children: [
            CustomWidgets.text(context, AppConstants.homeTabTitles[stateCurrentIndex], fontSize: stateCurrentIndex == 0 ? 24 : 22, fontWeight: FontWeight.w600, color: stateCurrentIndex == 0 ? isDarkMode ? Colors.white : WhatsAppColors.primary : null),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Animate(
                  controller: stateController.homeCameraIconAnimController.value,
                  effects: stateController.homeCamIconAnimCtrlEffects,
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
            Visibility(
                visible: stateCurrentIndex == 1 || stateCurrentIndex == 3,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      size: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                    )).animate().flipH(duration: const Duration(milliseconds: 150)).fadeIn(duration: const Duration(milliseconds: 150))),
            CustomPopupMenuButton(
              menuItems: const ["Sign out"],
              onSelected: (value) async {
                if (value == "Sign out") {
                  Get.dialog(
                    const LoadingDialog(
                      msg: "Signing out",
                    ),
                  );
                  Future.delayed(const Duration(seconds: 1), () async {
                    await UserAuth().googleSignOut();
                    Get.close(1);
                    Get.off(() => const WelcomeScreen());
                  });
                }
              },
            )
          ],
        );
      },
    );
  }
}
