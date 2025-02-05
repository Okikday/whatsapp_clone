import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';

class NewContactView extends StatelessWidget {
  const NewContactView({super.key});

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
                Expanded(child: ListView(
                  children: [
                    const SizedBox(height: 24,),
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
                        // contentPadding: const EdgeInsets.only(top: Constants.spaceExtraLarge, left: 8),
                        border: defaultInputBorder,
                        disabledBorder: defaultInputBorder,
                        enabledBorder: defaultInputBorder,
                        focusedBorder: activeInputBorder,
                      ),
                    ),
                  ],
                ),
        
                const SizedBox(height: 16,),
        
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
                    // contentPadding: const EdgeInsets.only(top: Constants.spaceMedium, left: 8),
                    border: defaultInputBorder,
                    disabledBorder: defaultInputBorder,
                    enabledBorder: defaultInputBorder,
                    focusedBorder: activeInputBorder,
                  ),
                ),
        
                const SizedBox(height: 16,),
        
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
                              CustomText("Country", color: isDarkMode ? WhatsAppColors.darkTextSecondary : WhatsAppColors.textSecondary),
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
                                      child: Icon(Icons.arrow_drop_down, color: isDarkMode ? Colors.white : Colors.black,))),
                                  alwaysShowSuffixIcon: true,
                                  pixelHeight: 36,
                                  inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
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
                                final String replacement = controller.text.replaceAll(RegExp(r'\s+'), '').replaceFirst(RegExp(r'^0|^\+234'), '');
                                if(controller.text != replacement) controller.text = replacement;
                              },
                              maxLines: 1,
                              pixelHeight: 42,
                              cursorColor: const CustomText(
                                    "",
                                  ).effectiveStyle(context).color ??
                                  Colors.green,
                              inputTextStyle: const CustomText("", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.center).style,
                              border: defaultInputBorder,
                              disabledBorder: defaultInputBorder,
                              enabledBorder: defaultInputBorder,
                              focusedBorder: activeInputBorder,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        
                const SizedBox(height: 48,),
                
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: CustomRichText(children: [CustomTextSpanData("Add information", fontWeight: FontWeight.w500, fontSize: 15, color: WhatsAppColors.emerald)]),
                ),
                  ],
                )),
        
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomElevatedButton(
                          pixelHeight: 42,
                          label: "Save",
                          textColor: Colors.black,
                          backgroundColor: isDarkMode ? WhatsAppColors.secondary : WhatsAppColors.primary,
                          screenWidth: 100,
                          textSize: Constants.fontSizeSmall + 1,
                          onClick: () {
                            
                          },
                        ),
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
