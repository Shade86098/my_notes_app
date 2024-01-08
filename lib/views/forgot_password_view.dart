import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes_app/services/auth/auth_exceptions.dart';
import 'package:my_notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes_app/services/auth/bloc/auth_event.dart';
import 'package:my_notes_app/services/auth/bloc/auth_state.dart';
import 'package:my_notes_app/utils/dialogs/error_dialog.dart';
import 'package:my_notes_app/utils/dialogs/password_reset_email_sent.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.exception != null) {
            if (!mounted) return;
            if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Please Enter a valid email');
            } else if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(context, 'User not Found');
            } else {
              await showErrorDialog(context, 'Some Error Occured');
            }
          }
          if (state.hasSentemail) {
            _controller.clear();
            if (!mounted) return;
            await showPasswordResetEmailSentDialog(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Please enter your email...'),
              TextField(
                autocorrect: false,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Your email here...',
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(AuthEventForgotPassword(email));
                },
                child: const Text('Send Passsword Reset Link'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text('Back to Login Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
