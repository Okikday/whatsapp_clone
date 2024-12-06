import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/colors.dart';

class StatusListTile extends StatelessWidget {
  final EdgeInsets? padding;
  const StatusListTile({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      overlayColor: WidgetStatePropertyAll(isDarkMode ? WhatsAppColors.secondary.withOpacity(0.25) : WhatsAppColors.primary.withOpacity(0.25)),
      onTap: (){

      },
      child: Container(
        width: 120,
        height: 160,
        padding: padding ?? EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(width: 120, height: 160, decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)),)
          ],
        ),
      ),
    );
  }
}