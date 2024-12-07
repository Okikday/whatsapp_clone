import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';

class StatusListTile extends StatelessWidget {
  final EdgeInsets? margin;
  final Widget? child;
  final ImageSource imgSrc;
  final File? imgFile;
  final String? imgURL;
  const StatusListTile({super.key, this.margin, this.child, this.imgSrc = ImageSource.network, this.imgFile, this.imgURL});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const double width = 120;
    const double height = 160;

    ImageProvider? imgProvider(){
      if(imgFile == null && imgURL == null){
        return const AssetImage("");
      }else if(imgURL != null && imgSrc == ImageSource.network){
        return NetworkImage(imgURL!);
      }else if(imgSrc == ImageSource.file && imgFile != null){
        return FileImage(imgFile!);
      }else{
        return null;
      }
    }

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
                        backgroundImage: imgProvider(),
                      )),
                  Positioned(
                    left: Constants.spaceSmall,
                    bottom: Constants.spaceExtraSmall,
                    child: CustomWidgets.text(context, "Someone"))
                ],
              ),
        ),
      ),
    );
  }
}
