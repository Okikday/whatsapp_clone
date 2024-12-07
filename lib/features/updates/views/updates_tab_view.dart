import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/features/updates/views/widgets/status_list_tile.dart';

class UpdatesTabView extends StatelessWidget {
  const UpdatesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final EdgeInsets generalPadding = EdgeInsets.symmetric(horizontal: Get.width > Get.height ? Get.width * 0.05 : 16);
    return Column(
      children: [
        const SizedBox(height: 16,),
        Padding(
          padding: generalPadding,
          child: SizedBox(width: Get.width, child: CustomWidgets.text(context, "Status", fontSize: Constants.fontSizeLarge, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 16,),
        SizedBox(
          height: 160,
          width: Get.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            padding: EdgeInsets.only(left: generalPadding.left),
            itemBuilder: (context, index){
            return StatusListTile(margin: EdgeInsets.only(left: index == 0 ? 0 : 4, right: index == 10 ? 0 : 4 ),);
          }),
        ),
      ],
    );
  
  }
}