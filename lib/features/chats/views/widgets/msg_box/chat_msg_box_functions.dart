import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:whatsapp_clone/common/colors.dart';

class ChatMsgBoxFunctions {

  static Widget widgetAttachmentIconButton({
    required bool isDarkMode,
    void Function()? onPressed,
  }) {
    return IconButton(
        onPressed: () {},
        icon: RotatedBox(
          quarterTurns: 3,
          child: Icon(
            Icons.attachment,
            color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.arsenic,
          ),
        ));
  }

  static Widget widgetCameraIconButton({required bool isDarkMode, required bool isVisible}) {
    return Visibility(
      visible: isVisible,
      child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.camera_alt_outlined,
            color: isDarkMode ? WhatsAppColors.battleshipGrey : WhatsAppColors.arsenic,
          )).animate().fadeIn(),
    );
  }



// Future<String> cropFromBottom(String imagePath, int cropHeight) async {
//   // Get original image dimensions
//   ImageProperties properties = await FlutterNativeImage.getImageProperties(imagePath);

//   if (properties != null) {
//     int originalHeight = properties.height!;
//     int originalWidth = properties.width!;

//     // Calculate cropping rectangle (starting from the bottom)
//     int cropTop = originalHeight - cropHeight;

//     // Crop the image
//     File croppedFile = await FlutterNativeImage.cropImage(
//       imagePath,
//       0,           // Crop from left
//       cropTop,     // Crop from calculated top
//       originalWidth,
//       cropHeight,
//     );

//     return croppedFile.path; // Return the path to the cropped image
//   } else {
//     throw Exception("Unable to get image properties");
//   }
// }


}
