import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/utilities/utilities_funcs.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';

class BuildTaggedMsgWidget extends StatelessWidget {
  final Color accentColor;
  final Color taggedMsgColor;
  final double width;
  final String taggedUserName;
  final bool hasMedia;
  final String taggedMsgContent;
  final String? mediaUrl;
  final bool isDarkMode;
  const BuildTaggedMsgWidget({
    super.key,
    this.accentColor = const Color(0xFFA791F9),
    required this.taggedMsgColor,
    required this.width,
    required this.taggedUserName, 
    required this.hasMedia, 
    required this.taggedMsgContent,
    this.mediaUrl,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle taggedMsgStyle = TextStyle(
      fontSize: 14,
      height: 1.0,
      color: WhatsAppColors.battleshipGrey,
      overflow: TextOverflow.ellipsis
    );
    final TextStyle taggedUserNameStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: accentColor,
      overflow: TextOverflow.clip,
    );
    
    final double msgContentWidth = hasMedia ? width * 0.6 : width - 12;
    final double height = (taggedUserNameStyle.fontSize ?? 15) + (UtilitiesFuncs.getTextLines(taggedMsgContent, taggedMsgStyle, maxWidth: msgContentWidth) * 18) + 18;
    // final double height = UtilitiesFuncs.getTextSize()
    final Image taggedImage = Image.asset(ImagesStrings.imgPlaceholder, height: height,);
    if(taggedMsgContent.isNotEmpty){
      return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: CustomElevatedButton(
        backgroundColor: taggedMsgColor,
        borderRadius: 12,
        pixelWidth: width,
        pixelHeight: height,
        overlayColor: WhatsAppColors.primary.withAlpha(20),
        contentPadding: const EdgeInsets.only(bottom: 2),
        onClick: () { },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              ColoredBox(
                color: accentColor,
                child: SizedBox(
                  width: 4,
                  height: height,
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: msgContentWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          taggedUserName,
                          style: taggedUserNameStyle,
                        ),
                        SizedBox(
                          width: msgContentWidth,
                          child: CustomText(
                          taggedMsgContent,
                          style: taggedMsgStyle,
                          maxLines: 3,
                          
                        ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
             if(hasMedia) FittedBox(child: taggedImage)
            ],
          ),
        ),
      ),
    );
    }
    return const SizedBox();
  }
}
