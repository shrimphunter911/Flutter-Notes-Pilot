import 'package:flutter/material.dart';
import 'package:pnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'Email sent. Please check',
    optionsBuilder: () => {
      'OK': null
    },
  );
}