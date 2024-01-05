import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        Text(text)
      ],
    ),
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return dialog;
    },
  );

  return () => Navigator.of(context).pop();
}
