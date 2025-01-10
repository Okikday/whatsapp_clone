import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final Color? backgroundColor;
  final void Function()? onClick;
  final void Function()? onLongClick;
  final double? borderRadius;
  final double? textSize;
  final double? pixelHeight; // Use pixel height for the normal height, declare for pixel if you want more customization over size
  final double? pixelWidth; // .... width for the normal width
  final double? screenHeight; // Use this for height with respect to the screen size
  final double? screenWidth;
  final Color? textColor;
  final EdgeInsets? contentPadding;

  const CustomTextButton({
    super.key,
    this.label,
    this.child,
    this.onClick,
    this.onLongClick,
    this.backgroundColor,
    this.borderRadius,
    this.textSize,
    this.pixelHeight,
    this.pixelWidth,
    this.screenHeight,
    this.screenWidth,
    this.textColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth != null ? MediaQuery.of(context).size.width * (screenWidth! / 100) : pixelWidth,
      height: screenHeight != null ? MediaQuery.of(context).size.height * (screenHeight! / 100) : pixelHeight,
      child: TextButton(
        onPressed: onClick,
        onLongPress: onLongClick,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(backgroundColor ?? Colors.transparent),
          padding: WidgetStatePropertyAll(contentPadding),
          overlayColor: WidgetStatePropertyAll(Colors.blue.withAlpha(26)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 24))),
          minimumSize: const WidgetStatePropertyAll(Size(4, 4)),
        ),
        child: child ?? Center(
          child: Text(
            label ?? '',
            style: TextStyle(
              fontSize: textSize ?? 16,
              color: textColor ?? Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
