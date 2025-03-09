import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';


class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final ValueNotifier<String> firstName;
  late final ValueNotifier<String> lastName;
  late final ValueNotifier<String> phoneNumber;
  late final ValueNotifier<String> errorMsg;

  @override
  void initState() {
    super.initState();
    firstName = ValueNotifier<String>("");
    lastName = ValueNotifier<String>("");
    phoneNumber = ValueNotifier<String>("");
    errorMsg = ValueNotifier<String>("");
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    errorMsg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final bool isDarkMode = appUiState.isDarkMode.value;
    final InputBorder activeInputBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary));
    final InputBorder defaultInputBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary));
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBgColor,
          statusBarIconBrightness: appUiState.isDarkMode.value ? Brightness.light : Brightness.dark,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        appBar: CustomAppBarContainer(
            scaffoldBgColor: scaffoldBgColor,
            padding: EdgeInsets.zero,
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: WhatsAppColors.textSecondary.withValues(alpha: 0.1)))),
              child: const Row(
                spacing: 4,
                children: [
                  BackButton(),
                  CustomText(
                    "New Contact",
                    fontSize: 20,
                  )
                ],
              ),
            )),
        body: SizedBox(
          height: appUiState.deviceHeight.value,
          width: appUiState.deviceWidth.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        // First name
                        Row(
                          spacing: 24,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.person_2_outlined, color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary),
                            Expanded(
                              child: CustomTextfield(
                                label: "First name",
                                maxLines: 1,
                                pixelHeight: 64,
                                cursorColor: const CustomText(
                                  "",
                                ).effectiveStyle(context).color ??
                                    Colors.green,
                                inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
                                border: defaultInputBorder,
                                disabledBorder: defaultInputBorder,
                                enabledBorder: defaultInputBorder,
                                focusedBorder: activeInputBorder,
                                onchanged: (text) {
                                  if (firstName.value != text) {
                                    firstName.value = text;
                                  }
                                },
                                onSubmitted: (text) {
                                  if (text.isNotEmpty && text.length >= 2) {
                                    errorMsg.value = "";
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    errorMsg.value = "Complete your first name";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // First name
                        Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: CustomTextfield(
                            label: "Last name",
                            maxLines: 1,
                            pixelHeight: 48,
                            pixelWidth: appUiState.deviceWidth.value * 0.8,
                            cursorColor: const CustomText(
                              "",
                            ).effectiveStyle(context).color ??
                                Colors.green,
                            inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
                            border: defaultInputBorder,
                            disabledBorder: defaultInputBorder,
                            enabledBorder: defaultInputBorder,
                            focusedBorder: activeInputBorder,
                            onchanged: (text) {
                              if (lastName.value != text) {
                                lastName.value = text.trim();
                              }
                            },
                            onSubmitted: (text) {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // Phone number
                        Row(
                          spacing: 24,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.call_outlined, color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary),
                            Expanded(
                              child: Row(
                                spacing: 16,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText("Country",
                                          color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary),
                                      GestureDetector(
                                        onTap: () {
                                          log("Tapped country");
                                        },
                                        child: CustomTextfield(
                                          isEnabled: false,
                                          defaultText: "NG +234",
                                          suffixIcon: SizedBox(
                                              width: 24,
                                              child: Align(
                                                  child: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                  ))),
                                          alwaysShowSuffixIcon: true,
                                          pixelHeight: 36,
                                          inputTextStyle:
                                          const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          border: defaultInputBorder,
                                          disabledBorder: defaultInputBorder,
                                          enabledBorder: defaultInputBorder,
                                          focusedBorder: activeInputBorder,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: CustomTextfield(
                                      hint: "Phone number",
                                      internalArgs: (controller, focusNode) {
                                        final String replacement =
                                        controller.text.replaceAll(RegExp(r'\s+'), '').replaceFirst(RegExp(r'^0|^\+234'), '');
                                        if (controller.text != replacement) controller.text = replacement;
                                        if (phoneNumber.value != replacement) phoneNumber.value = replacement;
                                      },
                                      maxLines: 1,
                                      pixelHeight: 42,
                                      cursorColor: const CustomText(
                                        "",
                                      ).effectiveStyle(context).color ??
                                          Colors.green,
                                      inputTextStyle:
                                      const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
                                      border: defaultInputBorder,
                                      disabledBorder: defaultInputBorder,
                                      enabledBorder: defaultInputBorder,
                                      focusedBorder: activeInputBorder,
                                      onSubmitted: (text) {
                                        if (text.isNotEmpty && text.length == 10) {
                                          if (firstName.value.isEmpty) {
                                            errorMsg.value = "Fill in first name";
                                          } else {
                                            errorMsg.value = "";
                                            FocusScope.of(context).unfocus();
                                          }
                                        } else {
                                          errorMsg.value = "Complete phone number";
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 48,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: CustomRichText(children: [
                            CustomTextSpanData("Add information", fontWeight: FontWeight.w500, fontSize: 15, color: WhatsAppColors.emerald)
                          ]),
                        ),
                      ],
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: errorMsg,
                          builder: (context, errorMsg, child) {
                            if (errorMsg.isNotEmpty) {
                              return CustomTextButton(
                                icon: Icon(
                                  Icons.error_outline_rounded,
                                  size: 16,
                                  color: Colors.red.shade100,
                                ),
                                child: CustomText(
                                  errorMsg,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red.shade100,
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomElevatedButton(
                        pixelHeight: 42,
                        label: "Save",
                        textColor: Colors.black,
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        backgroundColor: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                        screenWidth: 100,
                        textSize: Constants.fontSizeSmall + 1,
                        onClick: () async {
                          if(phoneNumber.value.startsWith("0")) phoneNumber.value = phoneNumber.value.substring(1);
                          bool isInfoVerified = firstName.value.isNotEmpty &&
                              phoneNumber.value.isNotEmpty &&
                              firstName.value.length >= 2 &&
                              phoneNumber.value.length == 10 &&
                              (int.tryParse(phoneNumber.value.toString()) != null);

                          LoadingDialog.showLoadingDialog(context,
                              msg: "Adding phone number", progressIndicatorColor: WhatsAppColors.secondary, backgroundColor: Get.theme.scaffoldBackgroundColor);
                          if (!isInfoVerified) {
                            Get.close(1);
                            if(errorMsg.value.isEmpty) errorMsg.value = "Error in details";
                            Future.delayed(Durations.extralong4, () {
                              errorMsg.value = "";
                            });
                            return;
                          }

                          final bool chatExists = (await AppData.chats.getChatById("chatId_${phoneNumber.value}")) != null;
                          if (chatExists) {
                            Get.close(1);
                            CustomSnackBar.showSnackBar(Get.context!,
                                content: "Phone number ${phoneNumber.value} already exists", vibe: SnackBarVibe.warning);
                            return;
                          }

                          try {
                            final currentTime = DateTime.now();
                            // adjust chat_id to random uuid
                            await AppData.chats.addChat(ChatModel(
                                chatId: "chatId_${phoneNumber.value}",
                                contactId: phoneNumber.value,
                                chatName: "${firstName.value} ${lastName.value}",
                                lastUpdated: currentTime, creationTime: currentTime));
                            Get.close(1);
                            CustomSnackBar.showSnackBar(Get.context!,
                                content: "Successfully added phone number", vibe: SnackBarVibe.success);
                          } catch (e) {
                            Get.close(1);
                            CustomSnackBar.showSnackBar(Get.context!, content: "Error adding phone number", vibe: SnackBarVibe.error);
                          }
                          Get.close(1);
                        },
                      ),
                    ],
                  ),
                ),
                ConstantSizing.columnSpacingSmall
              ],
            ),
          ),
        ),
      ),
    );
  }
}