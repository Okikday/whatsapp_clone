import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/encryption_service.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/firebase_data/firebase_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/features/authentication/controllers/auth_ui_controller.dart';
import 'package:whatsapp_clone/features/authentication/services/user_auth.dart';
import 'package:whatsapp_clone/features/authentication/use_cases/auth_functions.dart';
import 'package:whatsapp_clone/routes_names.dart';

class ContactVerificationView extends StatefulWidget {
  const ContactVerificationView({super.key});

  @override
  State<ContactVerificationView> createState() => _ContactVerificationViewState();
}

class _ContactVerificationViewState extends State<ContactVerificationView> {
  late final ValueNotifier<String> phoneNumber;
  @override
  void initState() {
    super.initState();
    phoneNumber = ValueNotifier("");
  }

  @override
  void dispose() {
    phoneNumber.dispose();
    super.dispose();
  }

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
                    height: appUiState.deviceHeight.value - appUiState.viewInsets.value.top - kToolbarHeight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.height > Get.width ? Get.width * 0.05 : Get.height * 0.05),
                      child: Column(
                        children: [
                          const CustomText("Enter your phone number", fontSize: Constants.fontSizeLarge),
                          const SizedBox(
                            height: Constants.spaceSmall,
                          ),
                          const CustomText("WhatsApp will need to verify your phone number. ",
                              fontSize: Constants.fontSizeSmall + 2, textAlign: TextAlign.center),
                          CustomRichText(children: [
                            CustomTextSpanData("Carrier charges may apply. ", fontSize: Constants.fontSizeSmall + 2),
                            CustomTextSpanData(
                              "What's my number?",
                              color: isDarkMode ? Colors.lightBlue : Colors.blue,
                              fontSize: Constants.fontSizeSmall + 2,
                            )
                          ], textAlign: TextAlign.center),
                          const SizedBox(
                            height: Constants.spaceMedium,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: CustomTextfield(
                              pixelWidth: appUiState.deviceWidth.value * 0.75,
                              isEnabled: false,
                              defaultText: "Nigeria",
                              inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
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
                                  inputTextStyle:
                                      const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
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
                                  selectionColor: WhatsAppColors.emerald,
                                  selectionHandleColor: WhatsAppColors.emerald,
                                  keyboardType: TextInputType.phone,
                                  internalArgs: (c, f) {
                                    final replacement = c.text.replaceAll(RegExp(r'\s+'), '').replaceFirst(RegExp(r'^0|^\+234'), '');
                                    if (c.text != replacement) c.text = replacement;
                                    if (phoneNumber.value != replacement) phoneNumber.value = replacement;
                                  },
                                  cursorColor: const CustomText(
                                        "",
                                      ).effectiveStyle(context).color ??
                                      Colors.green,
                                  inputTextStyle:
                                      const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
                                  border: underlineInputBorder,
                                  disabledBorder: underlineInputBorder,
                                  enabledBorder: underlineInputBorder,
                                  focusedBorder: underlineInputBorder,
                                )
                              ],
                            ),
                          ),
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
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        pixelHeight: 48,
                        label: "Next",
                        backgroundColor: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                        screenWidth: 100,
                        textSize: Constants.fontSizeSmall + 1,
                        onClick: () async {
                          if (phoneNumber.value.isEmpty) {
                            CustomSnackBar.showSnackBar(
                              context,
                              content: "Input Phone number",
                            );
                          }
                          if (!phoneNumber.value.isNumericOnly) return;
                          if (phoneNumber.value.startsWith("0")) phoneNumber.value = phoneNumber.value.substring(1);
                          if (phoneNumber.value.length != 10) return;

                          final ngnPhoneNumber = "+234${phoneNumber.value}";
                          await Future.delayed(Durations.medium1);

                          CustomSnackBar.showSnackBar(Get.context!, content: "Sending OTP not supported", vibe: SnackBarVibe.warning);

                          showDialog(
                              context: Get.context!,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Get.theme.scaffoldBackgroundColor,
                                  title: const CustomText(
                                    "Confirm phone number",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  content: CustomRichText(textAlign: TextAlign.center, children: [
                                    CustomTextSpanData(
                                      "Are you sure this is your phone number?\n",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomTextSpanData(ngnPhoneNumber,
                                        color: WhatsAppColors.emerald, fontSize: 14, fontWeight: FontWeight.bold)
                                  ]),
                                  actions: [
                                    CustomElevatedButton(
                                      borderRadius: ConstantSizing.borderRadiusCircle,
                                      backgroundColor: Colors.transparent,
                                      overlayColor: Get.theme.primaryColor.withValues(alpha: 0.1),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                      onClick: () => Get.close(1),
                                      child: const CustomText(
                                        "Edit",
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    CustomElevatedButton(
                                      borderRadius: ConstantSizing.borderRadiusCircle,
                                      backgroundColor: Colors.transparent,
                                      overlayColor: Get.theme.primaryColor.withValues(alpha: 0.1),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                      onClick: () async {
                                        try {

                                          Get.close(1); // Close the Confirm number Dialog
                                          LoadingDialog.showLoadingDialog(Get.context!,
                                              progressIndicatorColor: WhatsAppColors.secondary,
                                              backgroundColor: Get.theme.scaffoldBackgroundColor,);


                                          final Result googleSignInOutcome =
                                              await AuthFunctions().onGoogleSignIn(ngnPhoneNumber: ngnPhoneNumber);
                                          if(googleSignInOutcome.isSuccess != true ||
                                          googleSignInOutcome.value != true){
                                            await FirebaseGoogleAuth().googleSignOut();
                                            await UserDataFunctions().clearUserDetails();
                                            FirebaseFirestore.instance.collection("public_info").doc(AppData.userId).delete();
                                            Get.close(1);
                                            CustomSnackBar.showSnackBar(Get.context!,
                                                content: googleSignInOutcome.value, vibe: SnackBarVibe.error);
                                            return;
                                          }

                                          Get.close(1);
                                          navigator?.pop();
                                          Get.off(() => RoutesNames.homeView);
                                        } catch (e) {
                                          log("error: $e");
                                          await FirebaseGoogleAuth().googleSignOut();
                                          await UserDataFunctions().clearUserDetails();
                                          FirebaseFirestore.instance.collection("public_info").doc(AppData.userId).delete();
                                          Get.close(1);
                                          CustomSnackBar.showSnackBar(Get.context!,
                                              content: "Unknown error while signing in", vibe: SnackBarVibe.error);
                                        }
                                      },
                                      child: CustomText(
                                        "Continue",
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                );
                              });
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



