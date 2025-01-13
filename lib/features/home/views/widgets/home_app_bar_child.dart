import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/common/widgets/loading_dialog.dart';
import 'package:whatsapp_clone/features/authentication/services/user_auth.dart';
import 'package:whatsapp_clone/features/authentication/views/welcome_screen.dart';
import 'package:whatsapp_clone/features/home/controllers/home_ui_controller.dart';

class HomeAppBarChild extends StatelessWidget {
  const HomeAppBarChild({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final HomeUiController stateController = homeUiController;
      final int stateCurrentIndex = stateController.homeBottomNavBarCurrentIndex.value;

      return Row(
        children: [
          CustomWidgets.text(context, AppConstants.homeTabTitles[stateCurrentIndex],
              fontSize: stateCurrentIndex == 0 ? 24 : 22,
              fontWeight: FontWeight.w600,
              color: stateCurrentIndex == 0
                  ? isDarkMode
                      ? Colors.white
                      : WhatsAppColors.primary
                  : null),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Animate(
                controller: stateController.homeCameraIconAnimController.value,
                effects: stateCurrentIndex == 1 || stateCurrentIndex == 3 ? AppConstants.homeCamAnimforwardEffect : AppConstants.homeCamAnimBackwardEffect,
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
    });
  }
}
