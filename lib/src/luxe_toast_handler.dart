import 'dart:async';
import 'package:flutter/material.dart';
import 'luxe_toast_widget.dart';

enum LuxeToastPosition { top, bottom }

class LuxeToast {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void show(
      BuildContext context, {
        required String message,
        String title = "Notification",
        Color color = const Color(0xFF00FFCC),
        IconData icon = Icons.info,
        // Increased duration so you can admire the animation
        Duration duration = const Duration(seconds: 5),
        LuxeToastPosition position = LuxeToastPosition.top,
      }) {
    _removeToast();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: (position == LuxeToastPosition.top) ? 60 : null,
        bottom: (position == LuxeToastPosition.bottom) ? 60 : null,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: LuxeToastWidget(
            message: message,
            title: title,
            baseColor: color,
            icon: icon,
            duration: duration,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    _timer = Timer(duration, () {
      _removeToast();
    });
  }

  static void _removeToast() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }
}