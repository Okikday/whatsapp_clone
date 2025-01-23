import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    super.key,
    required this.homeBottomNavBarCurrentIndex,
    required this.isDarkMode,
    required this.scaffoldBgColor,
    required this.stateController,
    required this.pageController,
  });

  final int homeBottomNavBarCurrentIndex;
  final bool isDarkMode;
  final Color scaffoldBgColor;
  final HomeUiController stateController;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: homeBottomNavBarCurrentIndex,
      indicatorColor: isDarkMode ? const Color(0xFF103629) : const Color(0xFFD8FDD2),
      overlayColor: WidgetStatePropertyAll(const Color(0xFF103629).withAlpha(26)),
      backgroundColor: scaffoldBgColor,
      onDestinationSelected: (value) {
        if (value != homeBottomNavBarCurrentIndex) {
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
    );
  }
}
