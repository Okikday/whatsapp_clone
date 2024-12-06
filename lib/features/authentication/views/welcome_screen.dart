import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/images_strings.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/features/authentication/views/widgets/select_language_bottom_sheet.dart';
import 'package:whatsapp_clone/routes_names.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(systemNavigationBarColor: scaffoldBgColor),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: scaffoldBgColor,
          actions: const [
            CustomPopupMenuButton(
              menuItems: ["Help"],
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height > Get.width ? Get.width * 0.05 : Get.height * 0.05),
          child: Get.width > Get.height
              ? Row(
                  children: welcomeScreenWidgets(
                    context,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: welcomeScreenWidgets(
                    context,
                  ),
                ),
        ),
      ),
    );
  }
}

List<Widget> welcomeScreenWidgets(
  BuildContext context,
) {
  final bool isDarkMode = Get.theme.brightness == Brightness.dark;
  return [
    SizedBox(
        height: Get.height > Get.width ? Get.height * 0.4 : Get.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(Constants.spaceExtraLarge + 8),
          child: isDarkMode
              ? Image.asset(
                  ImagesStrings.welcomeImgDark,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  ImagesStrings.welcomeImgDark,
                  fit: BoxFit.contain,
                  color: const Color(0xFF2BAB6F),
                  colorBlendMode: BlendMode.srcIn,
                ),
        )),
    Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              CustomWidgets.text(context, "Welcome to WhatsApp", fontSize: Constants.fontSizeExtraLarge),
              const SizedBox(
                height: Constants.spaceMedium,
              ),
              CustomWidgets.richText(context, align: TextAlign.center, textSpans: [
                CustomWidgets.textSpan(context, "Read our ", fontSize: Constants.fontSizeSmall + 2),
                CustomWidgets.textSpan(context, "Privacy Policy",
                    fontSize: Constants.fontSizeSmall + 2,
                    color: isDarkMode ? Colors.lightBlue : Colors.blue,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.snackbar("Message", "Privacy Policy", snackPosition: SnackPosition.BOTTOM);
                      }),
                CustomWidgets.textSpan(context, ". Tap \"Agree and continue to accept the ", fontSize: Constants.fontSizeSmall + 2),
                CustomWidgets.textSpan(context, "Terms of Service",
                    fontSize: Constants.fontSizeSmall + 2,
                    color: isDarkMode ? Colors.lightBlue : Colors.blue,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.snackbar("Message", "Terms of service", snackPosition: SnackPosition.BOTTOM);
                      }),
                CustomWidgets.textSpan(context, ".", fontSize: Constants.fontSizeSmall + 2),
              ]),
              const SizedBox(
                height: Constants.spaceExtraLarge,
              ),
              CustomElevatedButton(
                elevation: 0,
                backgroundColor: isDarkMode ? Colors.white.withOpacity(0.1) : const Color(0xFFF7F7FA),
                overlayColor: isDarkMode ? WhatsAppColors.secondary.withOpacity(0.1) : WhatsAppColors.primary.withOpacity(0.1),
                onClick: () async {
                  if (context.mounted) {
                    await showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        showDragHandle: true,
                        isScrollControlled: true,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        builder: (context) {
                          return const SelectLanguageBottomSheet();
                        });
                  }
                },
                child: IntrinsicWidth(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.globe,
                          color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                          size: Constants.iconSizeMedium,
                        ),
                        const SizedBox(
                          width: Constants.spaceSmall,
                        ),
                        CustomWidgets.text(context, "English", color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary),
                        const SizedBox(
                          width: Constants.spaceSmall,
                        ),
                        Icon(FontAwesomeIcons.angleDown, color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary, size: Constants.iconSizeSmall),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomElevatedButton(
                pixelHeight: 48,
                label: "Agree and Continue",
                backgroundColor: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                screenWidth: 100,
                textSize: Constants.fontSizeSmall + 1,
                onClick: () {
                  log("Clicked to new page");
                  Get.to(() => RoutesNames.contactVerificationView,
                      transition: Transition.zoom, duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
                },
              ),
            ),
          ),
          const SizedBox(
            height: Constants.spaceExtraSmall,
          )
        ],
      ),
    )
  ];
}
