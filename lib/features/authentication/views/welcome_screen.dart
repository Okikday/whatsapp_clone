
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/features/authentication/views/contact_verification_view.dart';
import 'package:whatsapp_clone/features/authentication/views/widgets/select_language_bottom_sheet.dart';

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
        body: Obx(
              () {
            final bool isDarkMode = appUiState.isDarkMode.value;
            final double width = appUiState.deviceWidth.value;
            final double height = appUiState.deviceHeight.value;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: height > width ? Get.width * 0.05 : height * 0.05),
              child: Get.width > Get.height
                  ? Row(
                children: welcomeScreenWidgets(context, isDarkMode),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: welcomeScreenWidgets(context, isDarkMode),
              ),
            );
          },
        ),
      ),
    );
  }
}

List<Widget> welcomeScreenWidgets(
    BuildContext context,
    bool isDarkMode,
    ) {
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
              const CustomText("Welcome to WhatsApp", fontSize: Constants.fontSizeExtraLarge),
              const SizedBox(
                height: Constants.spaceMedium,
              ),
              CustomRichText(textAlign: TextAlign.center, children: [
                CustomTextSpanData("Read our ", fontSize: Constants.fontSizeSmall + 2),
                CustomTextSpanData("Privacy Policy",
                    fontSize: Constants.fontSizeSmall + 2,
                    color: isDarkMode ? Colors.lightBlue : Colors.blue,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.snackbar("Message", "Privacy Policy", snackPosition: SnackPosition.BOTTOM);
                      }),
                CustomTextSpanData(". Tap \"Agree and continue to accept the ", fontSize: Constants.fontSizeSmall + 2),
                CustomTextSpanData("Terms of Service",
                    fontSize: Constants.fontSizeSmall + 2,
                    color: isDarkMode ? Colors.lightBlue : Colors.blue,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.snackbar("Message", "Terms of service", snackPosition: SnackPosition.BOTTOM);
                      }),
                CustomTextSpanData(".", fontSize: Constants.fontSizeSmall + 2),
              ]),
              const SizedBox(
                height: Constants.spaceExtraLarge,
              ),
              CustomElevatedButton(
                borderRadius: ConstantSizing.borderRadiusLarge,
                backgroundColor: isDarkMode ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF7F7FA),
                overlayColor: isDarkMode ? WhatsAppColors.secondary.withValues(alpha: 0.1) : WhatsAppColors.primary.withValues(alpha: 0.1),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.globe,
                        color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                        size: Constants.iconSizeMedium,
                      ),
                      const SizedBox(
                        width: Constants.spaceSmall,
                      ),
                      CustomText("English", color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary),
                      const SizedBox(
                        width: Constants.spaceSmall,
                      ),
                      Icon(FontAwesomeIcons.angleDown, color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary, size: Constants.iconSizeSmall),
                    ],
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
                borderRadius: ConstantSizing.borderRadiusLarge,
                textSize: Constants.fontSizeSmall + 1,
                onClick: () {
                  Get.to(() => const ContactVerificationView(),
                      transition: Transition.rightToLeft, duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
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