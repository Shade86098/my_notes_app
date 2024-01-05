import 'package:my_notes_app/services/auth/auth_provider.dart';
import 'package:my_notes_app/services/auth/auth_user.dart';
import 'package:my_notes_app/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() async => provider.logOut();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() async =>
      provider.sendEmailVerification();

  @override
  Future<void> intialize() => provider.intialize();

  @override
  Future<void> refreshUserCredentials() => provider.refreshUserCredentials();

  @override
  Future<void> sendPasswordReset({required String email}) =>
      provider.sendPasswordReset(email: email);
}
