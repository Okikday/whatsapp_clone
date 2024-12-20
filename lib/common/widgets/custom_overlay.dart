import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomOverlay {
  static OverlayEntry? _overlayEntry;
  final BuildContext context;

  CustomOverlay(this.context);

  /// Show an overlay with a custom child.
  void showOverlay({
    required Widget child,
    Alignment alignment = Alignment.center,
    bool dismissible = true,
    EdgeInsets? padding,
    BoxConstraints? constraints,
    Color? overlayBgColor,
    
    /// Only works if dismissible is true
    ColoredBox? bgWidget,
  }) {
    // Remove any existing overlay
    if (_overlayEntry != null) {
      removeOverlay();
    }

    _overlayEntry = OverlayEntry(
      opaque: false,
      maintainState: true,
      builder: (context) {
        Widget overlayContent = Align(
          alignment: alignment,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: constraints ?? const BoxConstraints.tightFor(),
              child: child,
            ),
          ),
        );

        if (dismissible) {
          overlayContent = GestureDetector(
            onTap: removeOverlay,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                // Background to detect taps
                Positioned.fill(
                        child: bgWidget ?? ColoredBox(color: overlayBgColor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12)),
                      ),
                overlayContent,
              ],
            ),
          );
        }

        return overlayContent;
      },
    );

    // Insert the overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void removeOverlay() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove(); // Attempt to remove the overlay entry.
      } catch (e) {
        // Log or handle any errors gracefully.
        log('Error removing overlay: $e');
      }
      _overlayEntry = null;
    }
  }

  /// Check if an overlay is currently mounted.
  bool isOverlayMounted() => _overlayEntry != null;
}
