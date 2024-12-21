import 'dart:developer';
import 'package:flutter/material.dart';

class CustomOverlay {
  static OverlayEntry? _overlayEntry;
  final BuildContext context;

  CustomOverlay(this.context);

  /// Show an overlay with a custom child.
  void showOverlay({
    required Widget Function(BuildContext, void Function(VoidCallback)) builder,
    Alignment alignment = Alignment.center,
    bool dismissible = true,
    EdgeInsets? padding,
    BoxConstraints? constraints,
    Color? overlayBgColor,
    ColoredBox? bgWidget,
  }) {
    // Remove any existing overlay
    if (_overlayEntry != null) {
      removeOverlay();
    }

    // Create the overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            if (dismissible)
              GestureDetector(
                onTap: removeOverlay,
                behavior: HitTestBehavior.opaque,
                child: bgWidget ??
                    ColoredBox(
                      color: overlayBgColor ??
                          (Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.5)
                              : Colors.black.withOpacity(0.3)),
                    ),
              ),
            Align(
              alignment: alignment,
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: ConstrainedBox(
                  constraints: constraints ?? const BoxConstraints.tightFor(),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return builder(context, setState);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    // Insert the overlay entry
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Remove the overlay
  void removeOverlay() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (e) {
        log('Error removing overlay: $e');
      }
      _overlayEntry = null;
    }
  }

  /// Check if an overlay is currently mounted
  bool isOverlayMounted() => _overlayEntry != null;
}
