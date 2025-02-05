import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';
import 'package:whatsapp_clone/features/home/views/widgets/custom_app_bar_container.dart';

class ExpandImageView extends StatelessWidget {
  final String imageUrl;
  final String messageId;
  final String chatName;
  const ExpandImageView({super.key, required this.imageUrl, required this.messageId, required this.chatName});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    

    return Scaffold(
      body: Obx(
        () {
          final Color getCurrIconColor = appUiState.isDarkMode.value ? Colors.white : Colors.black;
    final double width = appUiState.deviceWidth.value;
    final double height = appUiState.deviceHeight.value;
          return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  width: width,
                  child: InteractiveViewer(
                    maxScale: 5.0,
                    minScale: 1.0,
                    child: Heroine(
                      tag: "msg_bubble_attachment_image$messageId",
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(Icons.error, size: 50, color: Color.fromARGB(255, 252, 123, 114)),
                          );
                        },
                        placeholder: (context, url) {
                          return Center(
                            child: Skeleton.leaf(
                              enabled: true,
                              child: SizedBox(
                                height: height * 0.5,
                                width: width,
                              ),
                            ),
                          );
                        },
                        width: width,
                        height: height,
                      ),
                    ),
                  ),
                ),
              ),
                  
              Positioned(
                child: Column(
                  children: [
                    CustomAppBarContainer(
                              scaffoldBgColor: scaffoldBgColor,
                              padding: EdgeInsets.zero,
                              child: Row(
                    children: [
                      BackButton(
                        color: getCurrIconColor,
                      ),
                      Expanded(child: CustomText(chatName, fontSize: 18, fontWeight: FontWeight.w500)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.star_border_rounded)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.turn_right_rounded,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                          ))
                    ],
                              )),
                  ],
                ),
              ),
            ],
          ),
                  );
        },
      ),
    );
  }
}
