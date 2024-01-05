import 'package:flutter/material.dart';
import 'package:my_notes_app/utils/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'We\'ve sent you an email, Please check your inbox',
    dialogOptionBuilder: () => {
      'OK': null,
    },
  );
}
