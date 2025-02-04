import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_textfield.dart';
import 'package:whatsapp_clone/features/authentication/controllers/auth_ui_controller.dart';
import 'package:whatsapp_clone/features/authentication/services/user_auth.dart';
import 'package:whatsapp_clone/common/widgets/loading_dialog.dart';
import 'package:whatsapp_clone/routes_names.dart';

class ContactVerificationView extends StatelessWidget {
  const ContactVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return Obx(
      () {
        final bool isDarkMode = appUiState.isDarkMode.value;
        final InputBorder underlineInputBorder =
            UnderlineInputBorder(borderSide: BorderSide(color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary));
        if (authUiController.systemNavBarColor.value != scaffoldBgColor) authUiController.setSystemNavBarColor(scaffoldBgColor);

        return AnnotatedRegion(
          value: SystemUiOverlayStyle(systemNavigationBarColor: authUiController.systemNavBarColor.value),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: scaffoldBgColor,
              surfaceTintColor: WhatsAppColors.appBar,
              actions: const [
                CustomPopupMenuButton(
                  menuItems: ["Link as Companion device", "Help"],
                )
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.height > Get.width ? Get.width * 0.05 : Get.height * 0.05),
                      child: Column(
                        children: [
                          const CustomText("Enter your phone number", fontSize: Constants.fontSizeLarge),
                          const SizedBox(
                            height: Constants.spaceSmall,
                          ),
                          const CustomText("WhatsApp will need to verify your phone number. ",
                              fontSize: Constants.fontSizeSmall + 2, align: TextAlign.center),
                          CustomWidgets.richText(context,
                              textSpans: [
                                CustomWidgets.textSpan(context, "Carrier charges may apply. ", fontSize: Constants.fontSizeSmall + 2),
                                CustomWidgets.textSpan(
                                  context,
                                  "What's my number?",
                                  color: isDarkMode ? Colors.lightBlue : Colors.blue,
                                  fontSize: Constants.fontSizeSmall + 2,
                                )
                              ],
                              align: TextAlign.center),
                          const SizedBox(
                            height: Constants.spaceMedium,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: CustomTextfield(
                              pixelWidth: appUiState.deviceWidth.value * 0.75,
                              isEnabled: false,
                              defaultText: "Nigeria",
                              inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, align: TextAlign.center).style,
                              textAlign: TextAlign.center,
                              suffixIcon: const Icon(
                                FontAwesomeIcons.caretDown,
                                color: WhatsAppColors.primary,
                              ),
                              alwaysShowSuffixIcon: true,
                              border: underlineInputBorder,
                              disabledBorder: underlineInputBorder,
                              enabledBorder: underlineInputBorder,
                              focusedBorder: underlineInputBorder,
                            ),
                          ),
                          const SizedBox(
                            height: Constants.spaceSmall,
                          ),

                          // Phone number
                          SizedBox(
                            width: Get.width * 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextfield(
                                  pixelWidth: appUiState.deviceWidth.value * 0.2,
                                  isEnabled: false,
                                  defaultText: "+ 234",
                                  inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, align: TextAlign.center).style,
                                  textAlign: TextAlign.center,
                                  border: underlineInputBorder,
                                  disabledBorder: underlineInputBorder,
                                  enabledBorder: underlineInputBorder,
                                  focusedBorder: underlineInputBorder,
                                ),
                                CustomTextfield(
                                  pixelWidth: appUiState.deviceWidth.value * 0.45,
                                  hint: "Phone number",
                                  maxLines: 1,
                                  cursorColor: const CustomText(
                                    "",
                                  ).effectiveStyle(context).color ?? Colors.green,
                                  inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, align: TextAlign.center).style,
                                  border: underlineInputBorder,
                                  disabledBorder: underlineInputBorder,
                                  enabledBorder: underlineInputBorder,
                                  focusedBorder: underlineInputBorder,
                                )
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: Constants.spaceLarge,
                          ),

                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: CustomElevatedButton(
                                pixelHeight: 48,
                                backgroundColor: isDarkMode ? Colors.white.withAlpha(75) : Colors.black.withAlpha(75),
                                onClick: () async {
                                  Get.dialog(
                                    const LoadingDialog(progressIndicatorColor: WhatsAppColors.secondary),
                                  );
                                  final Result result = await UserAuth().signInWithGoogle();
                                  Get.close(1);
                                  if (result.isSuccess || result.value == true) {
                                    navigator?.pop();
                                    Get.off(() => RoutesNames.homeView);
                                    Get.snackbar("Sign in", "Successfully signed in ✅");
                                  } else {
                                    Get.snackbar("Error Signing in", "${result.isError ? result.error : result.unavailable}");
                                    log(result.error.toString());
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.google,
                                      color: WhatsAppColors.primary,
                                    ),
                                    CustomText("Use Google", fontSize: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: Constants.spaceExtraSmall - 4,
                    left: Constants.spaceExtraSmall,
                    right: Constants.spaceExtraSmall,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomElevatedButton(
                        pixelHeight: 48,
                        label: "Next",
                        backgroundColor: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                        screenWidth: 100,
                        textSize: Constants.fontSizeSmall + 1,
                        onClick: () {
                          Get.snackbar(
                            "Unavailable",
                            "Not yet available",
                            duration: const Duration(milliseconds: 1000),
                          );
                        },
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
