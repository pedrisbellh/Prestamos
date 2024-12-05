import 'package:flutter/material.dart';

class SnackBarTop {
  static void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 16, // Ajusta la posición
        left: 0,
        right: 0,
        child: Material(
          elevation: 6.0,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remover el SnackBar después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
