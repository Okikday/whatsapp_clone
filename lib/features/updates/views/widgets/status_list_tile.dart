import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';

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
    const double width = 120;
    const double height = 160;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        overlayColor: WidgetStatePropertyAll(Colors.white.withAlpha(25)),
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        onTap: () {},
        child: SizedBox(
          width: width,
          height: height,
          child: child ??
              Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  SizedBox(
                    width: 120,
                    height: 160,
                    child: DecoratedBox(
                    
                    decoration: BoxDecoration(color: Colors.grey.withAlpha(100), borderRadius: BorderRadius.circular(12), image: DecorationImage(image: thumbnailURL != null ? Utilities.imgProvider(imgsrc: ImageSource.network, imgurl: thumbnailURL!)! : Utilities.imgProvider(imgsrc: ImageSource.asset,)!, fit: BoxFit.cover, colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.color)),),
                      
                    ),
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
