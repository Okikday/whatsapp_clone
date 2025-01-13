import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  // Utility for Text
  static CustomText text(
    BuildContext context,
    String text, {
    double fontSize = 12,
    double adjustSize = 0,
    Color? color,
    Color? darkColor,
    TextAlign? align,
    bool invertColor = false,
    TextOverflow? overflow = TextOverflow.visible,
    String? fontFamily,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration textDecoration = TextDecoration.none,
    Color decorationColor = Colors.black,
    List<Shadow> shadows = const [],
    double? height,
    double? letterSpacing,
    double? wordSpacing,
    TextDecorationStyle? decorationStyle,
    bool? softWrap,
    int? maxLines,
  }) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    color ??= isDarkMode ? (invertColor ? Colors.black : Colors.white) : (invertColor ? Colors.white : Colors.black);
    if (darkColor != null && isDarkMode) color = darkColor;

    return CustomText(
      text,
      color: color,
      fontSize: fontSize + adjustSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      textDecoration: textDecoration,
      decorationColor: decorationColor,
      shadows: shadows,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decorationStyle: decorationStyle,
      align: align ?? TextAlign.start,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
    );
  }

  // Utility method for RichText with TextSpan
  static RichText richText(
    BuildContext context, {
    required List<TextSpan> textSpans,
    TextAlign? align,
    double textScaleFactor = 1.0,
    TextOverflow overflow = TextOverflow.visible,
    int? maxLines,
  }) {
    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
      textAlign: align ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

// Utility method for creating a TextSpan
  static TextSpan textSpan(
    BuildContext context,
    String? text, {
    double fontSize = 12,
    double adjustSize = 0,
    Color? color,
    Color? darkColor,
    bool invertColor = false,
    String? fontFamily,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration textDecoration = TextDecoration.none,
    Color decorationColor = Colors.black,
    List<Shadow> shadows = const [],
    GestureRecognizer? recognizer, // To handle gestures like onTap
    VoidCallback? onEnter, // Trigger when pointer enters
    VoidCallback? onExit, // Trigger when pointer exits
  }) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    color ??= isDarkMode ? (invertColor ? Colors.black : Colors.white) : (invertColor ? Colors.white : Colors.black);
    if (darkColor != null && isDarkMode) color = darkColor;

    return TextSpan(
      text: text ?? "",
      style: TextStyle(
        color: color,
        fontSize: fontSize + adjustSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
        decorationColor: decorationColor,
        shadows: shadows,
      ),
      recognizer: recognizer,
      onEnter: (_) {
        if (onEnter != null) onEnter();
      },
      onExit: (_) {
        if (onExit != null) onExit();
      },
    );
  }
}

class CustomText extends StatelessWidget{
  final String data;
  final double fontSize;
  final double adjustSize;
  final Color? color;
  final Color? darkColor;
  final TextAlign? align;
  final bool invertColor;
  final TextOverflow? overflow;
  final String? fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;
  final Color decorationColor;
  final List<Shadow> shadows;
  final double? height;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextDecorationStyle? decorationStyle;
  final bool? softWrap;
  final int? maxLines;
  final TextStyle? style;

  const CustomText(
    this.data,{
    super.key,
    this.fontSize = 14.0,
    this.adjustSize = 0.0,
    this.color,
    this.darkColor,
    this.align,
    this.invertColor = false,
    this.overflow,
    this.fontFamily,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.textDecoration = TextDecoration.none,
    this.decorationColor = Colors.black,
    this.shadows = const [],
    this.height,
    this.letterSpacing,
    this.wordSpacing,
    this.decorationStyle,
    this.softWrap,
    this.maxLines,
    this.style,
  });

  /// Computes the final TextStyle
  TextStyle effectiveStyle(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    Color resolvedColor = color ??
        (isDarkMode
            ? (invertColor ? Colors.black : Colors.white)
            : (invertColor ? Colors.white : Colors.black));
    if (darkColor != null && isDarkMode) resolvedColor = darkColor!;

    return (style ?? const TextStyle()).copyWith(
      color: resolvedColor,
      fontSize: fontSize + adjustSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: textDecoration,
      decorationColor: decorationColor,
      shadows: shadows,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decorationStyle: decorationStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: effectiveStyle(context),
      textAlign: align,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
    );
  }
}
