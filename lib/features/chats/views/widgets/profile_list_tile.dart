import 'package:flutter/material.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';

class ProfileListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? titleColor;
  final Widget? trailing;
  final void Function()? onTap;

  const ProfileListTile({super.key, required this.leading, required this.title, this.onTap, this.subtitle, this.subtitleColor, this.trailing, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CustomText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16),
              child: CustomText(
                subtitle!,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),
      trailing: trailing,
      contentPadding: const EdgeInsets.only(left: 24, top: 2, bottom: 2, right: 12),
      onTap: () {
        if (onTap != null) onTap!();
      },
    );
  }
}
