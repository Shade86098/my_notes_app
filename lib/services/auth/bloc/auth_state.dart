import 'package:flutter/material.dart';
import 'package:my_notes_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user, {required super.isLoading});
}

class AuthStateNeedVerification extends AuthState {
  final Exception? exception;
  const AuthStateNeedVerification({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  AuthStateLoggedOut({
    required super.isLoading,
    super.loadingText,
    required this.exception,
  });

  @override
  List<Object?> get props => [
        exception,
        isLoading,
      ];
}

class AuthStateRegistering extends AuthState with EquatableMixin {
  final Exception? exception;

  AuthStateRegistering({
    required super.isLoading,
    super.loadingText,
    required this.exception,
  });

  @override
  List<Object?> get props => [
        exception,
        isLoading,
      ];
}

class AuthStateForgotPassword extends AuthState {
  final bool hasSentemail;
  final Exception? exception;
  const AuthStateForgotPassword({
    required super.isLoading,
    required this.exception,
    required this.hasSentemail,
  });
}
