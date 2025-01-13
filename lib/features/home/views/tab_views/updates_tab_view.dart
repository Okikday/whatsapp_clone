import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/features/updates/views/widgets/status_list_tile.dart';

class UpdatesTabView extends StatelessWidget {
  const UpdatesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets generalPadding = EdgeInsets.symmetric(horizontal: Get.width > Get.height ? Get.width * 0.05 : 16);
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
            child: SizedBox(
          height: 16,
        )),

        // Status updates section
        SliverToBoxAdapter(
          child: Padding(
            padding: generalPadding,
            child: CustomWidgets.text(context, "Status", fontSize: Constants.fontSizeLarge, fontWeight: FontWeight.w500),
          ),
        ),
        const SliverToBoxAdapter(
            child: SizedBox(
          height: 16,
        )),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 160,
            width: Get.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                padding: EdgeInsets.only(left: generalPadding.left, right: generalPadding.right),
                itemBuilder: (context, index) {
                  return StatusListTile(
                    margin: EdgeInsets.only(left: index == 0 ? 0 : 4, right: index == 10 ? 0 : 4),
                    title: "Someone $index",
                  );
                }),
          ),
        ),
        const SliverToBoxAdapter(
            child: SizedBox(
          height: 48,
        )),

        // Channels section
        SliverToBoxAdapter(
          child: Padding(
            padding: generalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomWidgets.text(context, "Channels", fontSize: Constants.fontSizeLarge, fontWeight: FontWeight.w500),
                CustomElevatedButton(
                  pixelWidth: 72,
                  contentPadding: const EdgeInsets.all(4),
                  backgroundColor: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidgets.text(context, "Explore", color: Theme.of(context).primaryColor, fontSize: 13),
                      Icon(FontAwesomeIcons.angleRight, size: 14, color: Theme.of(context).primaryColor)
                    ],
                  ),
                  onClick: () {},
                )
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
            child: SizedBox(
          height: 360,
          child: Center(child: CustomWidgets.text(context, "You haven't joined any Channels yet", color: Colors.grey)),
        ))
      ],
    );
  }
}
