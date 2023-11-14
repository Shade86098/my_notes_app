import 'package:flutter/material.dart';
import 'package:my_notes_app/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error occured',
    content: text,
    dialogOptionBuilder: () => {
      'OK': null,
    },
  );
}
