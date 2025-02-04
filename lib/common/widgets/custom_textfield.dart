import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Automatically disposes focusNode and Controller
class CustomTextfield extends StatefulWidget {
  final String? hint; // Shows hint
  final String? label; // Shows Label
  final double? pixelHeight; // Use pixel height for the normal height
  final double? pixelWidth; // Use pixel width for the normal width
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
  final bool? isDense;
  final bool obscureText; // Toggle for password field
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final double borderRadius;
  final Color? backgroundColor;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final EdgeInsets inputContentPadding;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool? isEnabled;
  final Color cursorColor;
  final int? maxLength;
  final BoxConstraints? constraints;
  final List<TextInputFormatter>? inputFormatters;
  final Function(TextEditingController controller, FocusNode focusNode)? internalArgs;
  final Function(TextEditingController controller, FocusNode focusNode)? dispose2;

  const CustomTextfield({
    super.key,
    this.hint,
    this.label,
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
    this.pixelHeight,
    this.pixelWidth,
    this.obscureText = false,
    this.hintStyle,
    this.labelStyle,
    this.inputTextStyle,
    this.borderRadius = 8,
    this.backgroundColor,
    this.border,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.controller,
    this.textAlign = TextAlign.start,
    this.inputContentPadding = EdgeInsets.zero,
    this.focusNode,
    this.maxLines,
    this.isEnabled = true,
    this.cursorColor = Colors.white,
    this.maxLength,
    this.inputFormatters,
    this.internalArgs,
    this.dispose2,
    this.isDense,
    this.constraints,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late TextEditingController controller;
  late FocusNode focusNode;
  bool showSuffixIcon = false;

  @override
  void initState() {
    super.initState();

    // Use widget's controller or create a new one
    controller = widget.controller ?? TextEditingController(text: widget.defaultText);
    // Use widget's focusNode or create a new one
    focusNode = widget.focusNode ?? FocusNode();

    // Add listeners
    controller.addListener(refreshSuffixIconState);
    focusNode.addListener(refreshSuffixIconState);
    if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);

    // Update the suffix icon state initially
    refreshSuffixIconState();
  }

  @override
  void dispose() {
    // Remove listeners
    controller.removeListener(refreshSuffixIconState);
    focusNode.removeListener(refreshSuffixIconState);
    if (widget.dispose2 != null) widget.dispose2!(controller, focusNode);

    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void refreshSuffixIconState() {
    if (widget.alwaysShowSuffixIcon) {
      showSuffixIcon = true;
    } else {
      if (widget.suffixIcon != null && focusNode.hasFocus) {
        showSuffixIcon = controller.text.isNotEmpty;
      } else {
        showSuffixIcon = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isDarkMode = mediaQueryData.platformBrightness == Brightness.dark;

    return TextField(
      enabled: widget.isEnabled,
      minLines: 1,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: controller,
      maxLength: widget.maxLength,
      focusNode: focusNode,
      onEditingComplete: () {
        if (widget.onEditingComplete != null) widget.onEditingComplete!();
        if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
      },
      onSubmitted: (value) {
        if (widget.onSubmitted == null) widget.onSubmitted!(value);
        if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
      },
      onChanged: (text) {
        if (text.isNotEmpty) setState(() => refreshSuffixIconState());
        if (widget.onchanged != null) widget.onchanged!(text);
        if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
      },
      onTap: () {
        refreshSuffixIconState();
        if (widget.ontap != null) widget.ontap!();
        if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
      },
      onTapOutside: (e) {
        if (widget.onTapOutside == null) focusNode.unfocus();
        if (widget.onTapOutside != null) widget.onTapOutside!();
        if (widget.internalArgs != null && focusNode.hasFocus) widget.internalArgs!(controller, focusNode);
      },
      style: widget.inputTextStyle ?? const TextStyle(color: Colors.white),
      cursorColor: widget.cursorColor,
      cursorRadius: const Radius.circular(12),
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        counterText: "",
        isDense: widget.isDense,
        hintText: widget.hint,
        labelText: widget.label,
        labelStyle: widget.labelStyle ??
            TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
        hintStyle: widget.hintStyle ??
            TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
        contentPadding: widget.inputContentPadding,
        border: widget.border ?? const OutlineInputBorder(),
        focusedBorder: widget.focusedBorder,
        enabledBorder: widget.enabledBorder,
        disabledBorder: widget.disabledBorder,
        constraints: widget.constraints ?? BoxConstraints.tightForFinite(width: widget.pixelWidth ?? 100, height: widget.pixelHeight ?? 48),
        filled: widget.backgroundColor == null ? false : true,
        fillColor: widget.backgroundColor,
        prefixIcon: widget.prefixIcon,
        suffixIcon: showSuffixIcon ? widget.suffixIcon! : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 4,
          minHeight: 4,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 4,
          minHeight: 4,
        ),
      ),
    );
  }
}
