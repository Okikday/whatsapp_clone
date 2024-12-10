import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CustomNativeTextInput extends StatelessWidget {
  final String? hint; // Shows hint
  final String? label; // Shows Label
  final double? pixelHeight; // Use pixel height for the normal height
  final double? pixelWidth; // Use pixel width for the normal width
  final double? maxHeight;
  final double? minHeight;
  final double? screenHeight; // Height based on screen size
  final double? screenWidth; // Width based on screen size
  final bool alwaysShowSuffixIcon; // Always show suffix icon if true
  final String defaultText; // Default text for the TextField
  final void Function()? ontap; // Tap action
  final void Function()? onTapOutside;
  final Function(String text)? onchanged; // Change listener for text
  final Function(String text)? onSubmitted;
  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText; // Toggle for password field
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final double? borderRadius;
  final Color? backgroundColor;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextEditingController? controller;
  final TextAlign? textAlign;
  final EdgeInsets? contentPadding;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool? isEnabled;
  final Color? cursorColor;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  const CustomNativeTextInput({
    super.key,
    this.hint,
    this.label,
    this.pixelHeight,
    this.pixelWidth,
    this.screenHeight,
    this.screenWidth,
    this.alwaysShowSuffixIcon = false,
    this.defaultText = "",
    this.ontap,
    this.onTapOutside,
    this.onchanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.labelStyle,
    this.hintStyle,
    this.inputTextStyle,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.controller,
    this.textAlign,
    this.contentPadding,
    this.focusNode,
    this.maxLines,
    this.isEnabled,
    this.cursorColor,
    this.maxLength,
    this.inputFormatters,
    this.minHeight,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    // View ID
    const String viewType = 'native-text-input';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{

    };

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}
