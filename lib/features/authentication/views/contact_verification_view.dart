import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_popup_menu_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_snackbar.dart';
import 'package:whatsapp_clone/data/firebase_data/firebase_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/features/authentication/controllers/auth_ui_controller.dart';
import 'package:whatsapp_clone/features/authentication/services/user_auth.dart';
import 'package:whatsapp_clone/features/authentication/views/verify_otp_view.dart';
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
                                  keyboardType: const TextInputType.numberWithOptions(),
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

                          // // Continue with Google button
                          // Expanded(
                          //   child: Align(
                          //     alignment: Alignment.center,
                          //     child: CustomElevatedButton(
                          //       pixelHeight: 48,
                          //       backgroundColor: isDarkMode ? Colors.white.withAlpha(75) : Colors.black.withAlpha(75),
                          //       onClick: () async {
                          //
                          //       },
                          //       child: const Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         spacing: 10,
                          //         children: [
                          //           Icon(
                          //             FontAwesomeIcons.google,
                          //             color: WhatsAppColors.primary,
                          //           ),
                          //           CustomText("Use Google", fontSize: 16)
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                        onClick: () async {
                          // Get.to(() => const VerifyOtpView());
                          if (!phoneNumber.value.isNumericOnly) return;
                          final ngnPhoneNumber = "+234${phoneNumber.value}";

                          CustomSnackBar.showSnackBar(context, content: "Unable to send OTP", vibe: SnackBarVibe.error);

                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const CustomText("Confirm phone number", fontSize: 15,),
                                  content: CustomRichText(
                                    textAlign: TextAlign.center, children: [
                                    CustomTextSpanData("Are you sure this is your phone number?\n"),
                                    CustomTextSpanData(ngnPhoneNumber, color: WhatsAppColors.emerald, fontSize: 14)
                                  ]),
                                  actions: [
                                    CupertinoButton(onPressed: () => Get.close(1), child: const CustomText("Edit", color: Colors.blueGrey,),),
                                    CupertinoButton(onPressed: () async{
                                      Get.close(1);
                                      await onGoogleSignIn(context);
                                      navigator?.push(LoadingDialog.loadingDialogBuilder());
                                      final Result userId = await UserDataFunctions().getUserId();
                                      if(!userId.isSuccess) {
                                        await FirebaseGoogleAuth().googleSignOut();
                                        await UserDataFunctions().clearUserDetails();
                                        Get.close(1);
                                        CustomSnackBar.showSnackBar(Get.context!, content: "Unable to complete sign up", vibe: SnackBarVibe.error);
                                        return;
                                      }
                                      final outcomeUpdatePhoneNumber = await FirebaseData().updateUserField(userId.value, {"phoneNumber": ngnPhoneNumber});
                                      if(!outcomeUpdatePhoneNumber.isSuccess){
                                        await FirebaseGoogleAuth().googleSignOut();
                                        await UserDataFunctions().clearUserDetails();
                                        Get.close(1);
                                        CustomSnackBar.showSnackBar(Get.context!, content: "Unable to complete sign up", vibe: SnackBarVibe.error);
                                        return;
                                      }
                                      log("Successfully added phone number to firebase");
                                      Get.close(1);
                                      CustomSnackBar.showSnackBar(Get.context!, content: "Successfully signed in with phone number and Google");

                                    }, child: const CustomText("Continue",  color: Colors.blueAccent,),)
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

Future<void> onGoogleSignIn(BuildContext context) async {
  navigator?.push(LoadingDialog.loadingDialogBuilder(progressIndicatorColor: WhatsAppColors.secondary));
  final Result result = await FirebaseGoogleAuth().signInWithGoogle();
  Get.close(1);
  if (result.isSuccess || result.value == true) {
    navigator?.pop();
    Get.off(() => RoutesNames.homeView);
    if (context.mounted) {
      CustomSnackBar.showSnackBar(Get.context!, content: "Successfully signed in ✅", vibe: SnackBarVibe.success);
    }
  } else {
    if (context.mounted) {
      CustomSnackBar.showSnackBar(context, content: "${result.isError ? result.error : result.unavailable}", vibe: SnackBarVibe.error);
    }

    log(result.error.toString());
  }
}
