import 'package:flutter/material.dart';
import 'package:my_notes_app/constants/routes.dart';
import 'package:my_notes_app/services/auth/auth_exceptions.dart';
import 'package:my_notes_app/services/auth/auth_service.dart';
import 'package:my_notes_app/utils/show_error_dialog.dart';
// import 'package:my_notes/utils/show_error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify")),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please verify your email."),
          const Text("If you haven't received the email yet click here:"),
          TextButton(
            onPressed: () {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () async {
              try {
                AuthService.firebase().refreshUserCredentials();
              } on UserNotLoggedInAuthException {
                showErrorDialog(context, 'User Not Logged In');
              } on GenericAuthException {
                showErrorDialog(context, 'Unable to Refresh user Credentias');
              }
              final user = AuthService.firebase().currentUser;
              if (user?.isEmailVerified ?? false) {
                showErrorDialog(context, 'Email is not Verified');
              } else {}
            },
            child: const Text("Done"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              if (!mounted) {
                return;
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                registerRoute,
                (_) => false,
              );
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
