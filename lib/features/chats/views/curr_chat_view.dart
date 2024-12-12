import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/images_strings.dart';
import 'package:whatsapp_clone/common/utilities.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_native_text_input.dart';

final CustomNativeTextInputController nativeTextInputController = CustomNativeTextInputController();

class CurrChatView extends StatefulWidget {
  const CurrChatView({super.key});

  @override
  State<CurrChatView> createState() => _CurrChatViewState();
}

class _CurrChatViewState extends State<CurrChatView> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBgColor, statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: scaffoldBgColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size(Get.width, 64),
          child: Container(
            color: scaffoldBgColor,
            width: Get.width,
            height: 64,
            margin: const EdgeInsets.only(top: kToolbarHeight - 26),
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                const BackButton(),
                CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  backgroundImage: Utilities.imgProvider(imgsrc: ImageSource.network),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(child: CustomWidgets.text(context, "Someone")),
                IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.video, size: 24, color: isDarkMode ? Colors.white : Colors.black)),
                IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      IconStrings.callsIconOutlined,
                      width: 24,
                      height: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                      colorBlendMode: BlendMode.srcIn,
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, size: 24, color: isDarkMode ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Chat background
              Container(
                height: Get.height,
                width: Get.width,
                decoration:
                    const BoxDecoration(color: Color(0xFF081010), image: DecorationImage(image: AssetImage(ImagesStrings.chatBackground), fit: BoxFit.fill)),
                child: CustomElevatedButton(
                    onClick: () {
                      log("Clicked");
                      // Send the updated state to the native side
                      // Find the nearest CustomNativeTextInputState in the widget tree
                      setState(() {
                        nativeTextInputController.updateArguments({
                        'hasFocus': false
                      });
                      });
                    },
                    label: "Play"),
              ),

              Positioned(
                width: Get.width,
                bottom: MediaQuery.viewInsetsOf(context).bottom.clamp(4.0, Get.height / 1.9),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: SizedBox(
                              width: 120,
                              height: 48,
                              child: ColoredBox(
                                  color: Colors.blue.withOpacity(0.1),
                                  child: CustomNativeTextInput(
                                      nativeTextInputController: nativeTextInputController,
                                      hint: "What is it",
                                      keyboardType: TextInputType.number,
                                      defaultText: "Default text",
                                      inputTextStyle: const TextStyle(fontSize: 24),
                                      cursorWidth: 4,
                                      cursorColor: Colors.red,
                                      backgroundColor: Colors.blue,
                                      cursorHandleColor: Colors.black,
                                      textStyles: [NativeTextStyle(start: 0, end: 4, style: "bold", color: Colors.orange, backgroundColor: Colors.red)])),
                            )
                            // child: CustomFlutterNativeTextField(
                            //   backgroundColor: scaffoldBgColor,
                            //   borderRadius: 64,
                            //   maxLines: 100,
                            //   prefixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.sticky_note_2_rounded)),
                            //   alwaysShowSuffixIcon: true,
                            //   suffixIcon: SizedBox(
                            //     width: 110,
                            //     child: Padding(
                            //       padding: EdgeInsets.only(right: 8),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           IconButton(onPressed: () {}, icon: Icon(Icons.attachment)),
                            //           IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined)),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            ),
                      ),
                      CustomElevatedButton(
                        shape: const CircleBorder(),
                        pixelWidth: 48,
                        pixelHeight: 48,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.mic,
                          size: 28,
                          color: scaffoldBgColor,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
