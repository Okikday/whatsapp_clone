import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/images_strings.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.theme.brightness == Brightness.dark;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(systemNavigationBarColor: scaffoldBgColor),
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size(Get.width, 64), child: Container(color: scaffoldBgColor, width: Get.width, height: 64, margin: const EdgeInsets.only(top: kToolbarHeight - 24), padding: EdgeInsets.only(left: Get.width > Get.height ? Get.width * 0.05 : 16, right: Get.width > Get.height ? Get.width * 0.05 : 0), child: Row(children: [
              CustomWidgets.text(context, "WhatsApp", fontWeight: FontWeight.w600, fontSize: 24, color: isDarkMode ? WhatsAppColors.background : WhatsAppColors.primary),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){}, icon: Image.asset(IconStrings.cameraIconHome, width: 24, height: 24, color: isDarkMode ? Colors.white : Colors.black, colorBlendMode: BlendMode.srcIn,)),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, size: 24,))
                ],
              ))
            ],),),),
        bottomNavigationBar: Obx(
          () => NavigationBar(
            selectedIndex: homeUiController.homeBottomNavBarCurrentIndex.value,
            indicatorColor: isDarkMode ? const Color(0xFF103629) : const Color(0xFFD8FDD2),
            overlayColor: WidgetStatePropertyAll(const Color(0xFF103629).withOpacity(0.1)),
            backgroundColor: scaffoldBgColor,
            onDestinationSelected: (value) => homeUiController.setHomeBottomNavBarCurrentIndex(value),
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
      ),
    );
  }
}
