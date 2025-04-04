import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';

class CallsTabView extends StatelessWidget {
  const CallsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final EdgeInsets generalPadding = EdgeInsets.symmetric(horizontal: Get.width > Get.height ? Get.width * 0.05 : 16);
    return Column(
      children: [
        const SizedBox(height: 12,),
        Padding(
          padding: generalPadding,
          child: SizedBox(width: Get.width, child: const CustomText("Favourites", fontSize: Constants.fontSizeMedium, textAlign: TextAlign.left)),
        ),
        const SizedBox(height: 16,),
        ListTile(
          
          contentPadding: generalPadding.copyWith(top: 4, bottom: 4),
          title: const CustomText("Add Favourite", fontSize: Constants.fontSizeMedium - 1),
          leading: CircleAvatar(backgroundColor: WhatsAppColors.secondary, child: Icon(Icons.favorite, color: scaffoldBgColor, size: 24,), ),
          onTap: () {
            
          },
        ),
        const Expanded(child: Center(child: CustomText("You have no recent calls"),))
      ],
    );
  }
}