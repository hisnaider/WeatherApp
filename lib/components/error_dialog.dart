import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';

/// Display an error dialog.
///
/// This function shows an error dialog with a title, an error message, and an
/// error code.
///
/// Parameters:
/// [error]: A map containing message and code of the error.
void errorDialog(Map<String, dynamic> error) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Algo deu errado",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(error["message"]),
              const SizedBox(
                height: 10,
              ),
              Opacity(opacity: 0.5, child: Text("Erro ${error["code"]}")),
            ],
          ),
        ),
      );
    },
  );
}
