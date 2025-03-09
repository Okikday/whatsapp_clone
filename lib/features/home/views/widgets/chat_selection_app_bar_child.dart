import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/features/home/controllers/chats_tab_ui_controller.dart';

import '../../../../common/colors.dart';

class ChatSelectionAppBarChild extends StatelessWidget {
  const ChatSelectionAppBarChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        final Color getCurrIconColor = appUiState.isDarkMode.value ? Colors.white : Colors.black;
        final Color primaryColor = Get.theme.primaryColor;
        return Row(
          children: [
            BackButton(
              color: getCurrIconColor,
            ),
            Expanded(
                child: CustomText(chatsTabUiController.chatTilesSelected.length.toString(), fontSize: 18, fontWeight: FontWeight.w500)),
            IconButton(
                onPressed: () {},
                icon: Image.asset(
                  IconStrings.pinOutlined,
                  width: 24,
                  height: 24,
                  color: getCurrIconColor,
                  colorBlendMode: BlendMode.srcIn,
                )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Get.theme.scaffoldBackgroundColor,
                          title: const CustomText(
                            "Delete this chat?",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.translate(
                                  offset: const Offset(-8, 0),
                                  child: Checkbox(value: false, onChanged: (value) {}, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,)),
                              Expanded(
                                child: CustomRichText(children: [
                                  CustomTextSpanData("Also delete media received in this", fontSize: 14),
                                  CustomTextSpanData(" chat from gallery", fontSize: 14),
                                ], ),
                              ),
                            ],
                          ),
                          actions: [
                            CustomElevatedButton(
                              backgroundColor: Colors.transparent,
                              onClick: () => Get.close(1),
                              overlayColor: primaryColor.withValues(alpha: 0.1),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              child: CustomText(
                                "Cancel",
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CustomElevatedButton(
                              backgroundColor: Colors.transparent,
                              onClick: () async {
                                Get.close(1);
                                LoadingDialog.showLoadingDialog(context, msg: "Deleting selected chats", progressIndicatorColor: WhatsAppColors.secondary, backgroundColor: Get.theme.scaffoldBackgroundColor);

                                chatsTabUiController.chatTilesSelected.forEach((key, value) async {
                                  if (value != null) await AppData.chats.deleteChatWithMsgs(value);
                                });
                                chatsTabUiController.clearSelectedChatTiles();
                                Get.close(1);
                              },
                              overlayColor: primaryColor.withValues(alpha: 0.1),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                child: CustomText(
                                  "Delete",
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(
                  Icons.delete,
                  color: getCurrIconColor,
                )),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications_off_outlined, color: getCurrIconColor)),
            IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined, color: getCurrIconColor)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: getCurrIconColor))
          ],
        );
      },
    );
  }
}