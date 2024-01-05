import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes_app/constants/routes.dart';
import 'package:my_notes_app/services/auth/auth_exceptions.dart';
import 'package:my_notes_app/services/auth/auth_service.dart';
import 'package:my_notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes_app/services/auth/bloc/auth_event.dart';
import 'package:my_notes_app/services/auth/bloc/auth_state.dart';
import 'package:my_notes_app/utils/dialogs/error_dialog.dart';
// import 'package:my_notes/utils/show_error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedVerification) {
          if (state.exception is UserNotLoggedInAuthException) {
            await showErrorDialog(
              context,
              "Critical Error: User Not Logged In",
            );
          } else if (state.exception is EmailNotVerifiedAuthException) {
            await showErrorDialog(
              context,
              "Email not Verified",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Authentication Error",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Verify")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "We've sent you an email verification. Please verify your email. If you haven't received the email yet click here:",
                textAlign: TextAlign.center,
                textHeightBehavior: TextHeightBehavior(),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: const Text("Send Email Verification"),
              ),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventCheckVerified(),
                      );
                },
                child: const Text("Done"),
              ),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventLogout(),
                      );
                },
                child: const Text("Restart"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
