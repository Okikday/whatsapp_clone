import 'dart:developer';
import 'package:flutter/material.dart';

class CustomOverlay {
  static OverlayEntry? _overlayEntry;
  final BuildContext context;

  CustomOverlay(this.context);

  /// Show an overlay with a custom child.
  void showOverlay({
    required Widget Function(BuildContext, void Function(VoidCallback)) builder,
    Alignment alignment = Alignment.topLeft,
    bool dismissible = true,
    BoxConstraints? constraints,
    Color? overlayBgColor,
    Size? size,
  }) {
    // Remove any existing overlay
    if (_overlayEntry != null) {
      removeOverlay();
    }

    // Create the overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          color: overlayBgColor ?? Colors.black.withValues(alpha: 0.3),
          child: Stack(
            children: [
              if (dismissible)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: removeOverlay,
                    behavior: HitTestBehavior.opaque,
                  ),
                ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: size?.width,
                  height: size?.height,
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInCubic,
                    alignment: alignment,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return builder(context, setState);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Insert the overlay entry
    try{
      Overlay.of(context).insert(_overlayEntry!);
    }catch(e){
      log("Unable to add Overlay: $e");
    }
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