import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final Color? backgroundColor;
  final double? elevation;
  final void Function()? onClick;
  final double? borderRadius;
  final double? textSize;
  final double? pixelHeight;   // Use pixel height for the normal height, declare for pixel if you want more customization over size
  final double? pixelWidth;   // .... width for the normal width
  final double? screenHeight;   // Use this for height with respect to the screen size
  final double? screenWidth;
  final Color? textColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Color? overlayColor;
  final EdgeInsets? contentPadding;

  const CustomElevatedButton({
    super.key,
    this.label,
    this.child,
    this.onClick,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.textSize,
    this.pixelHeight,
    this.pixelWidth,
    this.screenHeight,
    this.screenWidth,
    this.textColor,
    this.side,
    this.shape,
    this.overlayColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth != null ? MediaQuery.of(context).size.width * (screenWidth! / 100) : pixelWidth,
      height: screenHeight != null ? MediaQuery.of(context).size.height * (screenHeight! / 100) : pixelHeight,
      child: ElevatedButton(
          onPressed: onClick,
          
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(backgroundColor ?? Theme.of(context).primaryColor),
            padding: WidgetStatePropertyAll(contentPadding ?? EdgeInsets.zero),
            overlayColor: WidgetStatePropertyAll(overlayColor ?? Colors.blue.withOpacity(0.1)),
            elevation: WidgetStatePropertyAll(elevation),
            shape: WidgetStatePropertyAll(shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 24) )),
            side: WidgetStatePropertyAll(side),
            minimumSize: const WidgetStatePropertyAll(Size(4, 4))
          ),
          child: child ?? Center(
            child: CustomWidgets.text(context, label, fontSize: textSize ?? 8, color: textColor ?? Colors.white)
          ),
          ),
    );
  }
}