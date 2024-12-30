import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  // Utility for Text
  static Text text(
    BuildContext context,
    String? text, {
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
    if (darkColor != null && MediaQuery.of(context).platformBrightness == Brightness.dark) color = darkColor;
    return Text(
      text ?? "",
      style: TextStyle(
        color: color ??
            (MediaQuery.of(context).platformBrightness == Brightness.dark
                ? (invertColor == true ? Colors.black : Colors.white)
                : (invertColor == true ? Colors.white : Colors.black)),
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
      ),
      textAlign: align ?? TextAlign.start,
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
    if (darkColor != null && MediaQuery.of(context).platformBrightness == Brightness.dark) color = darkColor;

    return TextSpan(
      text: text ?? "",
      style: TextStyle(
        color: color ??
            (MediaQuery.of(context).platformBrightness == Brightness.dark
                ? (invertColor == true ? Colors.black : Colors.white)
                : (invertColor == true ? Colors.white : Colors.black)),
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
