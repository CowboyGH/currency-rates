import 'package:flutter/material.dart';

/// Отображает SnackBar с сообщением [message] в контексте [context].
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        width: MediaQuery.sizeOf(context).width * 0.6,
        content: Text(
          message,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
}
