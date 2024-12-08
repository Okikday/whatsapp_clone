import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities.dart';

class StatusListTile extends StatelessWidget {
  final EdgeInsets? margin;
  final Widget? child;
  final ImageSource profilePhotoSrc;
  final File? profilePhotoFile;
  final String? profilePhotoURL;
  final String title;
  final String? thumbnailURL;
  final File? thumbnailFile;
  final ImageSource thumbnailSrc;
  const StatusListTile(
      {super.key,
      this.margin,
      this.child,
      this.profilePhotoSrc = ImageSource.network,
      this.profilePhotoFile,
      this.profilePhotoURL,
      required this.title,
      this.thumbnailURL,
      this.thumbnailFile,
      this.thumbnailSrc = ImageSource.network});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const double width = 120;
    const double height = 160;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        onTap: () {},
        child: SizedBox(
          width: width,
          height: height,
          child: child ??
              Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
                  ),
                  Positioned(
                      left: Constants.spaceSmall,
                      top: Constants.spaceSmall,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: Utilities.imgProvider(imgsrc: profilePhotoSrc, imgfile: profilePhotoFile, imgurl: profilePhotoURL),
                      )),
                  Positioned(left: Constants.spaceSmall, bottom: Constants.spaceExtraSmall, child: CustomWidgets.text(context, title))
                ],
              ),
        ),
      ),
    );
  }
}
