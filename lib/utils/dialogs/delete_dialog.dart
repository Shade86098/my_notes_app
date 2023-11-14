import 'package:flutter/material.dart';
import 'package:my_notes_app/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    dialogOptionBuilder: () => {
      'Cancel': false,
      'delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
