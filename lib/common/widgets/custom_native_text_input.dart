// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/features/chats/views/chat_view.dart';

class CustomNativeTextInput extends StatefulWidget {
  final CustomNativeTextInputController nativeTextInputController;
  final String? hint; // Shows hint
  final double? pixelHeight; // Use pixel height for the normal height
  final double? pixelWidth; // Use pixel width for the normal width
  final int? inputBoxHeight;
  final int? inputBoxWidth;
  final String defaultText; // Default text for the TextField
  final void Function()? ontap; // Tap action
  final void Function()? onTapOutside;
  final void Function(String text)? onchanged; // Change listener for text
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final double? borderRadius;
  final Color? backgroundColor;
  final BoxBorder? boxBorder;
  final TextAlign? textAlign;
  final EdgeInsets? inputPadding;
  final int? minLines;
  final int? maxLines;
  final bool? isEnabled;
  final Color? cursorColor;
  final int? maxLength;
  final bool? hasFocus;
  final List<TextInputFormatter>? inputFormatters;
  final List<NativeTextStyle>? textStyles;
  final int? cursorWidth;
  final Color? cursorHandleColor;
  final Future<void> Function(NativeTextInputModel args)? internalArgs;
  final int? minHeight;
  final double? maxHeight;
  final int? lines;
  final Color? highlightColor;
  final Color? fontColor;
  final Color? debugBoxColor;
  final EdgeInsets? contentPadding;
  const CustomNativeTextInput(
      {super.key,
      required this.nativeTextInputController,
      this.hint,
      this.pixelHeight,
      this.pixelWidth,
      this.defaultText = "",
      this.ontap,
      this.onTapOutside,
      this.onchanged,
      this.keyboardType,
      this.suffixIcon,
      this.prefixIcon,
      this.hintStyle,
      this.inputTextStyle,
      this.borderRadius,
      this.backgroundColor,
      this.boxBorder,
      this.textAlign,
      this.inputPadding,
      this.contentPadding,
      this.minLines,
      this.maxLines,
      this.isEnabled,
      this.cursorColor,
      this.maxLength,
      this.inputFormatters,
      this.hasFocus,
      this.inputBoxWidth,
      this.inputBoxHeight,
      this.textStyles,
      this.cursorWidth,
      this.cursorHandleColor,
      this.internalArgs,
      this.minHeight,
      this.maxHeight,
      this.lines,
      this.highlightColor,
      this.fontColor,
      this.debugBoxColor
  });

  @override
  State<CustomNativeTextInput> createState() => CustomNativeTextInputState();
}

class CustomNativeTextInputState extends State<CustomNativeTextInput> {
  late MethodChannel _channel; // Declare a private MethodChannel
  late Map<String, dynamic> creationParams;
  late ValueNotifier<Map<String, dynamic>> creationParamsNotifier;

  @override
  void initState() {
    super.initState();
    widget.nativeTextInputController.attach(this);
    creationParams = NativeTextInputModel(
      hint: widget.hint,
      defaultText: widget.defaultText,
      fontSize: widget.inputTextStyle?.fontSize,
      fontColor: widget.inputTextStyle?.color,
      isEnabled: widget.isEnabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      cursorColor: widget.cursorColor,
      contentPadding: widget.contentPadding ?? EdgeInsets.zero,
      textStyles: widget.textStyles,
      cursorWidth: widget.cursorWidth,
      cursorHandleColor: widget.cursorHandleColor,
      hasFocus: widget.hasFocus,
      inputBoxHeight: widget.inputBoxHeight,
      inputBoxWidth: widget.inputBoxWidth,
      hintTextColor: widget.hintStyle?.color,
      lines: widget.lines,
      minHeight: widget.minHeight,
      maxHeight: widget.maxHeight?.toInt(),
      highlightColor: widget.highlightColor,
    ).toMap();

    creationParamsNotifier = ValueNotifier(creationParams);

    creationParamsNotifier.addListener(() {
      updateArguments(creationParamsNotifier.value);
    });
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null); // Remove handler
    widget.nativeTextInputController.detach(); // Detach the state when the widget is disposed

    super.dispose();
  }

  @override
  void didUpdateWidget(CustomNativeTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    final updatedParams = NativeTextInputModel(
      hint: widget.hint,
      defaultText: widget.defaultText,
      fontSize: widget.inputTextStyle?.fontSize,
      fontColor: widget.inputTextStyle?.color,
      isEnabled: widget.isEnabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      cursorColor: widget.cursorColor,
      contentPadding: widget.contentPadding ?? EdgeInsets.zero,
      textStyles: widget.textStyles,
      cursorWidth: widget.cursorWidth,
      cursorHandleColor: widget.cursorHandleColor,
      hasFocus: widget.hasFocus,
      inputBoxHeight: widget.inputBoxHeight,
      inputBoxWidth: widget.inputBoxWidth,
      hintTextColor: widget.hintStyle?.color,
      lines: widget.lines,
      minHeight: widget.minHeight,
      maxHeight: widget.maxHeight?.toInt(),
      highlightColor: widget.highlightColor,
    ).toMap();

    if (creationParams != updatedParams) {
      updateCreationParams(updatedParams);
    }
  }

  void updateCreationParams(Map<String, dynamic> newParams) {
    setState(() {
      creationParams = newParams;
      updateArguments(newParams);
    });
  }

  void updateArguments(Map<String, dynamic> args) {
    // Send the updated arguments to the native platform view
    _channel.invokeMethod('updateArguments', creationParams);
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = 'native-text-input';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.boxBorder,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
      ),
      child: SizedBox(
        width: widget.pixelWidth,
        height: widget.pixelHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.prefixIcon != null) widget.prefixIcon!,
            Expanded(
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: widget.inputPadding == null ? 0 : (widget.inputPadding?.top ?? 0),),
                    Expanded(
                      child: SizedBox(
                        height: widget.maxHeight,
                        child: Padding(
                          padding: widget.inputPadding ?? EdgeInsets.zero,
                          child: ColoredBox(
                            color: widget.debugBoxColor ?? Colors.transparent,
                            child: PlatformViewLink(
                              viewType: viewType,
                              surfaceFactory: (context, controller) {
                                return AndroidViewSurface(
                                  controller: controller as AndroidViewController,
                                  gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
                                  hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                                );
                              },
                              onCreatePlatformView: (params) {
                                _channel = MethodChannel('native_text_input_${params.id}'); // Initialize the MethodChannel
                            
                                _channel.setMethodCallHandler((call) async {
                                  final results = await Future.wait([
                                    CustomNativeTextInputFunctions.getText(_channel),
                                    CustomNativeTextInputFunctions.getProperties(_channel),
                                  ]);
                            
                                  final String? text = results[0] as String?;
                                  final NativeTextInputModel? properties = results[1] as NativeTextInputModel?;
                            
                                  // Handle callbacks only if necessary
                                  if (text != null) widget.onchanged?.call(text);
                                  if (properties != null) widget.internalArgs?.call(properties);
                                  if (call.method == 'onTap') widget.ontap?.call();
                            
                                  // Update state only if required
                                  setState(() {
                                    nativeTextInputController.updateArguments({});
                                  });
                                });
                            
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
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: widget.inputPadding == null ? 0 : (widget.inputPadding?.bottom ?? 0),),
                  ],
                ),
              ),
            ),
            if (widget.suffixIcon != null) widget.suffixIcon!,
          ],
        ),
      ),
    );
  }
}

class CustomNativeTextInputController {
  CustomNativeTextInputState? _state;

  void attach(CustomNativeTextInputState state) => _state = state;
  void detach() => _state = null;
  void updateArguments(Map<String, dynamic> args) => _state?.updateArguments(args);
  void updateCreationParams() => _state?.updateCreationParams(_state!.creationParamsNotifier.value);
}

class CustomNativeTextInputFunctions {
  static Future<String?> getText(MethodChannel channel) async {
    try {
      return await channel.invokeMethod<String>('getText');
    } catch (e) {
      log("error fetching text");
      return null;
    }
  }

  static Future<NativeTextInputModel?> getProperties(MethodChannel channel) async {
    try {
      final properties = await channel.invokeMethod<Map>('getProperties');

      if (properties != null) {
        return NativeTextInputModel.fromMap(Map<String, dynamic>.from(properties));
      } else {
        return null;
      }
    } catch (e) {
      log('Error retrieving properties: $e');
      return null;
    }
  }
}

class NativeTextInputModel {
  final String? hint; // Hint text for the TextField
  final String? label;
  final String? defaultText; // Default text to display in the TextField
  final double? fontSize; // Font size for the text
  final Color? fontColor;
  final bool? isEnabled; // Whether the TextField is enabled
  final int? minLines;
  final int? maxLines; // Maximum number of lines
  final TextAlign? textAlign; // Text alignment
  final TextInputType? keyboardType; // Input type
  final int? maxLength; // Maximum length of the text
  final Color? cursorColor; // Cursor color
  final EdgeInsets? contentPadding; // Padding as EdgeInsets
  final List<NativeTextStyle>? textStyles; // List of styles to apply to text
  final bool? hasFocus;
  final int? cursorWidth;
  final Color? cursorHandleColor;
  final int? inputBoxHeight;
  final int? inputBoxWidth;
  final Color? hintTextColor;
  final int? minHeight;
  final int? maxHeight;
  final int? lines;
  final Color? highlightColor;

  NativeTextInputModel({
    this.hint,
    this.label,
    this.defaultText,
    this.fontSize = 16.0,
    this.isEnabled = true,
    this.minLines,
    this.maxLines,
    TextAlign? textAlign,
    TextInputType? keyboardType,
    this.maxLength,
    this.cursorColor,
    this.contentPadding,
    this.textStyles,
    this.hasFocus = false,
    this.cursorWidth = 4,
    this.cursorHandleColor,
    this.inputBoxHeight,
    this.inputBoxWidth,
    this.hintTextColor,
    this.lines,
    this.maxHeight,
    this.minHeight,
    this.highlightColor,
    this.fontColor,
  })  : textAlign = textAlign ?? TextAlign.start,
        keyboardType = keyboardType ?? TextInputType.text;

  // Converts the model to a Map
  Map<String, dynamic> toMap() {
    return {
      'hint': hint,
      'label': label,
      'defaultText': defaultText,
      'fontSize': fontSize,
      'isEnabled': isEnabled,
      'minLines': minLines,
      'maxLines': maxLines,
      'textAlign': textAlign.toString().split('.').last,
      'keyboardType': keyboardType == TextInputType.streetAddress
          ? "address"
          : keyboardType == const TextInputType.numberWithOptions(decimal: true)
              ? "numberDecimal"
              : keyboardType == TextInputType.visiblePassword
                  ? "password"
                  : keyboardType.toString().split('.').last,
      'maxLength': maxLength,
      'cursorColor': colorToHex(cursorColor),
      'contentPadding': contentPadding != null ? [contentPadding!.left, contentPadding!.top, contentPadding!.right, contentPadding!.bottom] : null,
      'textStyles': textStyles?.map((style) => style.toMap()).toList(),
      'hasFocus': hasFocus,
      'cursorWidth': cursorWidth,
      'cursorHandleColor': colorToHex(cursorHandleColor),
      'inputBoxHeight': inputBoxHeight,
      'inputBoxWidth': inputBoxWidth,
      'hintTextColor': colorToHex(hintTextColor),
      'minHeight': minHeight,
      'maxHeight': maxHeight,
      'lines': lines,
      'highlightColor': colorToHex(highlightColor),
      'fontColor': colorToHex(fontColor)
    };
  }

  // Creates a model instance from a Map
  factory NativeTextInputModel.fromMap(Map<String, dynamic> map) {
    return NativeTextInputModel(
        hint: map['hint'] as String?,
        label: map['label'] as String?,
        defaultText: map['defaultText'] as String?,
        fontSize: (map['fontSize'] as num?)?.toDouble(),
        isEnabled: map['isEnabled'] as bool? ?? true,
        minLines: (map['minLines'] as int?),
        maxLines: map['maxLines'] as int?,
        textAlign: _parseTextAlign(map['textAlign'] as String?),
        keyboardType: _parseTextInputType(map['keyboardType'] as String?),
        maxLength: map['maxLength'] as int?,
        cursorColor: hexToColor(map['cursorColor'] as String?),
        contentPadding: (map['contentPadding'] as List?) != null
            ? EdgeInsets.fromLTRB(
                (map['contentPadding'][0] as num).toDouble(),
                (map['contentPadding'][1] as num).toDouble(),
                (map['contentPadding'][2] as num).toDouble(),
                (map['contentPadding'][3] as num).toDouble(),
              )
            : null,
        textStyles: (map['textStyles'] as List?)?.map((styleMap) => NativeTextStyle.fromMap(Map<String, dynamic>.from(styleMap))).toList(),
        hasFocus: (map['hasFocus'] as bool?) ?? false,
        cursorWidth: (map['cursorWidth'] as int),
        cursorHandleColor: hexToColor(map['cursorHandleColor'] as String?),
        inputBoxHeight: (map['inputBoxHeight'] as int?),
        inputBoxWidth: (map['inputBoxWidth'] as int?),
        hintTextColor: hexToColor(map['hintTextColor'] as String?),
        minHeight: (map['minHeight'] as int?),
        maxHeight: (map['maxHeight'] as int?),
        lines: (map['lines'] as int?),
        highlightColor: hexToColor(map['highlightColor'] as String?),
        fontColor: hexToColor(map['fontColor'] as String?));
  }

  static TextAlign _parseTextAlign(String? value) {
    switch (value) {
      case 'center':
        return TextAlign.center;
      case 'end':
        return TextAlign.end;
      default:
        return TextAlign.start;
    }
  }

  static TextInputType _parseTextInputType(String? value) {
    switch (value) {
      case 'number':
        return TextInputType.number;
      case 'emailAddress':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'password':
        return TextInputType.visiblePassword;
      case 'multiline':
        return TextInputType.multiline;
      case 'url':
        return TextInputType.url;
      case 'datetime':
        return TextInputType.datetime;
      case 'name':
        return TextInputType.name;
      case 'address':
        return TextInputType.streetAddress;
      case 'numberDecimal':
        return const TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }
}

class NativeTextStyle {
  final int start;
  final int end;
  final String style; // e.g., "bold", "italic", "underline"
  final Color? color; // Text color
  final Color? backgroundColor; // Background color
  final double? letterSpacing;
  final double? lineHeight;

  NativeTextStyle({required this.start, required this.end, required this.style, this.color, this.backgroundColor, this.letterSpacing, this.lineHeight});

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
      'style': style,
      'color': colorToHex(color),
      'backgroundColor': colorToHex(backgroundColor),
      'letterSpacing': letterSpacing ?? 0.0, // Default to 0.0 if null
      'lineHeight': lineHeight ?? 0.0, // Default to 0.0 if null
    };
  }

  // Creates a style instance from a Map
  factory NativeTextStyle.fromMap(Map<String, dynamic> map) {
    return NativeTextStyle(
      start: map['start'] as int,
      end: map['end'] as int,
      style: map['style'] as String,
      color: hexToColor(map['color'] as String?),
      backgroundColor: hexToColor(map['backgroundColor'] as String?),
      letterSpacing: map['letterSpacing'] as double?,
      lineHeight: map['lineHeight'] as double?,
    );
  }
}

String? colorToHex(Color? color) {
  if (color == null) return null;
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

Color? hexToColor(String? hexString) {
  if (hexString == null) return null;

  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) {
    buffer.write('ff');
  }
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
