import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadioButtons {
  final List<String> items;
  final Color? activeColor;
  final Color? focusColor;
  final Color? hoverColor;
  final double? splashRadius;
  
  final RxString _currentValue = ''.obs;

  CustomRadioButtons({
    required this.items,
    this.activeColor,
    this.focusColor,
    this.hoverColor,
    this.splashRadius,
    String? initialValue,
  }) {
    _currentValue.value = initialValue ?? (items.isNotEmpty ? items.first : '');
  }

  /// Get the current value
  String get currentValue => _currentValue.value;

  /// Set the current value
  void setCurrentValue(String value) => _currentValue.value = value;

  /// Generate a radio button widget
  Widget getRadio({
    required int index,
    void Function(String value)? onChanged,
  }) {
    if (index < 0 || index >= items.length) {
      throw RangeError('Index out of range for items list.');
    }

    return Obx(
      () => Radio<String>(
        value: items[index],
        groupValue: _currentValue.value,
        activeColor: activeColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        splashRadius: splashRadius,
        onChanged: (value) {
          if (value != null) {
            setCurrentValue(value);
            onChanged?.call(value);
          }
        },
      ),
    );
  }
}
