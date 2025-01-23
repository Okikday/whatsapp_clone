import 'package:flutter/material.dart';
import 'package:whatsapp_clone/app/controllers/app_ui_state.dart';

class CustomAppBarContainer extends StatelessWidget implements PreferredSizeWidget {
  final Color scaffoldBgColor;
  final EdgeInsets? padding;
  final Widget child;
  final double appBarHeight;
  const CustomAppBarContainer({super.key, required this.scaffoldBgColor, this.padding, required this.child, this.appBarHeight = 56});

  @override
  Size get preferredSize {
    return Size(appUiState.deviceWidth.value, appBarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final double width = appUiState.deviceWidth.value;
    final double height = appUiState.deviceHeight.value;
    final double topPadding = MediaQuery.paddingOf(context).top;
    return ColoredBox(
      color: scaffoldBgColor,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
            width: width,
            height: appBarHeight,
            child: Padding(
              padding: padding ?? EdgeInsets.only(left: width > height ? width * 0.05 : 16, right: width > height ? width * 0.05 : 0),
              child: child,
            )),
      ),
    );
  }
}
