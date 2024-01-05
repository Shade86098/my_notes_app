import 'package:bloc/bloc.dart';
import 'package:my_notes_app/services/auth/auth_exceptions.dart';
import 'package:my_notes_app/services/auth/auth_provider.dart';
import 'package:my_notes_app/services/auth/bloc/auth_event.dart';
import 'package:my_notes_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUninitialized(isLoading: true),
        ) {
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.intialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedVerification(
          exception: null,
          isLoading: false,
        ));
      } else {
        emit(AuthStateLoggedIn(user, isLoading: false));
      }
    });

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(AuthStateRegistering(exception: null, isLoading: false));
      },
    );

    //register
    on<AuthEventRegister>(
      (event, emit) async {
        final String email = event.email;
        final String password = event.password;
        emit(
          AuthStateRegistering(
            exception: null,
            isLoading: true,
            loadingText: 'Registering... Please wait',
          ),
        );
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(
            AuthStateRegistering(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedVerification(
              exception: null, isLoading: false));
        } on Exception catch (exception) {
          emit(
            AuthStateRegistering(
              exception: exception,
              isLoading: false,
            ),
          );
        }
      },
    );

    //login
    on<AuthEventLogin>((event, emit) async {
      final email = event.email;
      final password = event.password;
      emit(
        AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while We log you in ',
        ),
      );
      try {
        final user = await provider.login(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(
            AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedVerification(
            exception: null,
            isLoading: false,
          ));
        } else {
          emit(
            AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(
            AuthStateLoggedIn(
              user,
              isLoading: false,
            ),
          );
        }
      } on Exception catch (exception) {
        emit(
          AuthStateLoggedOut(
            exception: exception,
            isLoading: false,
          ),
        );
      }
    });

    //check if email verified
    on<AuthEventCheckVerified>((event, emit) async {
      emit(const AuthStateNeedVerification(
          exception: null,
          isLoading: true,
          loadingText: 'Checking if Email is Verified... '));
      try {
        final user = await provider.refreshUserCredentials();
        if (user.isEmailVerified) {
          emit(
            const AuthStateNeedVerification(
              exception: null,
              isLoading: false,
            ),
          );
          emit(
            AuthStateLoggedIn(
              user,
              isLoading: false,
            ),
          );
        } else {
          emit(
            AuthStateNeedVerification(
              exception: EmailNotVerifiedAuthException(),
              isLoading: false,
            ),
          );
        }
      } on Exception catch (exception) {
        emit(
          AuthStateNeedVerification(
            exception: exception,
            isLoading: false,
          ),
        );
      }
    });

    //email Verification
    on<AuthEventSendEmailVerification>(
      (event, emit) {
        provider.sendEmailVerification();
        emit(state);
      },
    );

    //logout
    on<AuthEventLogout>(
      (event, emit) async {
        emit(AuthStateLoggedOut(exception: null, isLoading: true));
        try {
          await provider.logOut();
          emit(AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (exception) {
          emit(AuthStateLoggedOut(exception: exception, isLoading: false));
        }
      },
    );

    //forgot password
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentemail: false,
          isLoading: false,
        ));
        final email = event.email;
        if (email == null) {
          return; //user just wants to go to forgot-password screen
        }
        //user wants to actually send a forgot-password email
        emit(const AuthStateForgotPassword(
          exception: null,
          isLoading: true,
          hasSentemail: false,
        ));
        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(
            email: email,
          );
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }
        emit(AuthStateForgotPassword(
          exception: exception,
          isLoading: false,
          hasSentemail: didSendEmail,
        ));
      },
    );
  }
}
