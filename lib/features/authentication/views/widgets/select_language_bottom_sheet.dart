import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/common/constants.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
import 'package:whatsapp_clone/common/widgets/custom_radio_buttons.dart';

class SelectLanguageBottomSheet extends StatelessWidget {
  const SelectLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of CustomRadioButtons
    final CustomRadioButtons customRadioButtons = CustomRadioButtons(
      items: AppConstants.whatsappLanguages.keys.toList(),
      activeColor: Colors.green,
    );
    
    return DraggableScrollableSheet(
      maxChildSize: 1.0,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      expand: false,
      snap: true,
      snapSizes: const [0.5],
      builder: (context, scrollController) {
        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SizedBox(
            child: Column(
              children: [
                SizedBox(
                  height: 36,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const CloseButton(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomWidgets.text(
                          context,
                          "App's Language",
                          align: TextAlign.left,
                          fontSize: Constants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: AppConstants.whatsappLanguages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: customRadioButtons.getRadio(
                          index: index,
                        ),
                        title: CustomWidgets.text(context, AppConstants.whatsappLanguages.keys.toList()[index]),
                        subtitle: CustomWidgets.text(context, AppConstants.whatsappLanguages.values.toList()[index], color: WhatsAppColors.darkTextSecondary),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
