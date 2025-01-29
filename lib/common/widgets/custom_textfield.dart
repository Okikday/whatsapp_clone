import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Automatically disposes focusNode and Controller
class CustomTextfield extends StatefulWidget{
  final String? hint; // Shows hint
  final String? label; // Shows Label
  final double pixelHeight; // Use pixel height for the normal height
  final double pixelWidth; // Use pixel width for the normal width
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
  final EdgeInsets contentPadding;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool? isEnabled;
  final Color cursorColor;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Function(TextEditingController controller, FocusNode focusNode)? internalArgs;
  final Function(TextEditingController controller, FocusNode focusNode)? dispose2;

  const CustomTextfield(
      {super.key,
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
      this.pixelHeight = 48,
      this.pixelWidth = 120,
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
      this.contentPadding = EdgeInsets.zero,
    });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield>{
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

  BorderSide resolveTextFieldBorder(){
    final bool hasFocus = focusNode.hasFocus;
    final bool? isEnabled = widget.isEnabled;
    if(!hasFocus){ // Doesn't have focus?
      if(isEnabled == null || isEnabled){
        return widget.enabledBorder?.borderSide ?? BorderSide.none;
      }else{
        return widget.disabledBorder?.borderSide ?? BorderSide.none;
      }
    }
    if(hasFocus){
      if(isEnabled == null || isEnabled){
        widget.focusedBorder?.borderSide ?? BorderSide.none;
      }
    }
    return widget.border?.borderSide ?? BorderSide.none;
  }
  

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isDarkMode = mediaQueryData.platformBrightness == Brightness.dark;

    return SizedBox(
      width: widget.pixelWidth,
      height: widget.pixelHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(resolveTextFieldBorder()),
          color: widget.backgroundColor ?? (isDarkMode ? Colors.black : Colors.white),
          borderRadius: BorderRadius.circular(widget.borderRadius)
        ),
        child: Padding(
          padding: widget.contentPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             if(widget.prefixIcon != null) widget.prefixIcon!,
             
              Expanded(
                child: TextField(
                  enabled: widget.isEnabled,
                  maxLines: widget.maxLines,
                  textAlign: widget.textAlign,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  controller: controller,
                  maxLength: widget.maxLength,
                  focusNode: focusNode,
                  onEditingComplete: widget.onEditingComplete,
                  onSubmitted: (value) => widget.onSubmitted == null ? () {} : widget.onSubmitted!(value),
                  onChanged: (text) {
                    setState(() {
                      if (text.isNotEmpty) {
                        refreshSuffixIconState();
                      }
                    });
                    if (widget.onchanged != null) {
                      widget.onchanged!(text);
                    }
                  },
                  onTap: () {
                    refreshSuffixIconState();
                    if (widget.ontap != null) widget.ontap!();
                  },
                  onTapOutside: (e) {
                    if (widget.onTapOutside == null) focusNode.unfocus();
                    if (widget.onTapOutside != null) widget.onTapOutside!();
                  },
                  style: widget.inputTextStyle ?? const TextStyle(color: Colors.white),
                  cursorColor: widget.cursorColor,
                  cursorRadius: const Radius.circular(12),
                  inputFormatters: widget.inputFormatters,
                  decoration: InputDecoration(
                    counterText: "",
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
                    border: UnderlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide.none)
                  ),
                ),
              ),
             if(widget.suffixIcon != null) showSuffixIcon ? widget.suffixIcon! : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
