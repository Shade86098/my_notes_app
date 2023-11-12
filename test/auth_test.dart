import 'package:my_notes_app/services/auth/auth_exceptions.dart';
import 'package:my_notes_app/services/auth/auth_provider.dart';
import 'package:my_notes_app/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('Cannot Logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedExeption>()),
      );
    });
    test('Should be able to initialize', () async {
      await provider.intialize();
      expect(provider.isInitialized, true);
    });
    test('User Should be null after initialization', () {
      expect(provider.currentUser, null);
    });
    test(
      'Should be able to initialize within 3s',
      () async {
        await provider.intialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );
    test('Create user should delegate to logIn Function', () async {
      final badEmailUser = provider.createUser(
        email: 'foobar@gmail.com',
        password: 'anypassword',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );
      final user = await provider.createUser(
        email: 'email',
        password: 'password',
      );
      expect(
        provider.currentUser,
        user,
      );
      expect(user.isEmailVerified, false);
    });
    test('Login user should be able to get verified', () async {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to Logout and login again', () async {
      await provider.logOut();
      await provider.login(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedExeption implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw NotInitializedExeption();
    }
    await Future.delayed(const Duration(seconds: 2));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> intialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw NotInitializedExeption();
    }
    if (_user == null) {
      throw UserNotFoundAuthException();
    }
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) {
      throw NotInitializedExeption();
    }
    if (email == 'foobar@gmail.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'foo@bar.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedExeption();
    }
    final user = _user;
    if (user == null) {
      throw UserNotFoundAuthException();
    }
    const newUser = AuthUser(
      isEmailVerified: true,
      email: 'foo@bar.com',
    );
    _user = newUser;
  }

  @override
  Future<void> refreshUserCredentials() {
    // TODO: implement refreshUserCredentials
    throw UnimplementedError();
  }
}
