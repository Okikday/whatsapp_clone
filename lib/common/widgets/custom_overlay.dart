import 'dart:developer';
import 'package:flutter/material.dart';

class CustomOverlay {
  static OverlayEntry? _overlayEntry;
  final BuildContext context;

  CustomOverlay(this.context);

  /// Show an overlay with a custom child.
  void showOverlay({
    required Widget child,
    bool dismissible = true,
    HitTestBehavior hitTestBehavior = HitTestBehavior.opaque,
  }) {
    // Remove any existing overlay
    if (_overlayEntry != null) {
      removeOverlay();
    }

    // Create the overlay entry
    _overlayEntry = OverlayEntry(
      canSizeOverlay: true,
      builder: (context) {
        return child;
      },
    );

    // Insert the overlay entry
    try {
      Overlay.of(context).insert(_overlayEntry!);
    } catch (e) {
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
