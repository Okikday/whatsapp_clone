import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/app/views/dev_settings_view.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
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
      final ThemeData themeData = Theme.of(context);
      final bool isDarkMode = themeData.brightness == Brightness.dark;
      final HomeUiController stateController = homeUiController;
      final int stateCurrentIndex = stateController.homeBottomNavBarCurrentIndex.value;
      final scaffoldBgColor = themeData.scaffoldBackgroundColor;

      return Row(
        children: [
          Expanded(
            child: CustomText(AppConstants.homeTabTitles[stateCurrentIndex],
                fontSize: stateCurrentIndex == 0 ? 24 : 22,
                fontWeight: FontWeight.w600,
                color: stateCurrentIndex == 0
                    ? isDarkMode
                    ? Colors.white
                    : WhatsAppColors.primary
                    : null),
          ),
          Animate(
            controller: stateController.homeCameraIconAnimController.value,
            effects: stateCurrentIndex == 1 || stateCurrentIndex == 3
                ? AppConstants.homeCamAnimforwardEffect
                : AppConstants.homeCamAnimBackwardEffect,
            child: IconButton(
                onPressed: () {},
                icon: Image.asset(
                  IconStrings.cameraHome,
                  width: 24,
                  height: 24,
                  color: isDarkMode ? Colors.white : Colors.black,
                  colorBlendMode: BlendMode.srcIn,
                )),
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
          PopupMenuTheme(
            data: PopupMenuThemeData(color: scaffoldBgColor, shadowColor: Colors.blueGrey),
            child: CustomPopupMenuButton(
              menuItems: const ["Sign out", "dev settings"],
              onSelected: (value) async {
                if (value == "Sign out") {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: scaffoldBgColor,
                          shadowColor: Colors.blueGrey,
                            title: const CustomText(
                              "Signing out",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            content: const CustomText(
                              "Are you sure you want to sign out?",
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            actions: [
                              CustomElevatedButton(
                                backgroundColor: Colors.transparent,
                                onClick: () => Get.close(1),
                                overlayColor: Get.theme.primaryColor.withValues(alpha: 0.1),
                                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: CustomText(
                                  "Exit",
                                  color: themeData.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomElevatedButton(
                                backgroundColor: Colors.transparent,
                                overlayColor: Get.theme.primaryColor.withValues(alpha: 0.1),
                                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                onClick: () async{
                                  Get.close(1);
                                  LoadingDialog.showLoadingDialog(context, msg: "Signing out", backgroundColor: Get.theme.scaffoldBackgroundColor, progressIndicatorColor: Get.theme.primaryColor);
                                  await Future.delayed(const Duration(seconds: 1), () async {});
                                  await FirebaseGoogleAuth().googleSignOut();
                                  Get.close(1);
                                  Get.off(() => const WelcomeScreen());

                                },
                                child: const CustomText(
                                  "Sign out",
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]);
                      });
                } else if (value == "dev settings") {
                  Get.to(() => const DevSettingsView());
                }
              },
            ),
          )
        ],
      );
    });
  }
}

//  CustomPopupMenuButton(
//             menuItems: const ["Sign out"],
//             onSelected: (value) async {
//               if (value == "Sign out") {
//                 Get.dialog(
//                   const LoadingDialog(
//                     msg: "Signing out",
//                   ),
//                 );
//                 Future.delayed(const Duration(seconds: 1), () async {
//                   await UserAuth().googleSignOut();
//                   Get.close(1);
//                   Get.off(() => const WelcomeScreen());
//                 });
//               }
//             },
//           )