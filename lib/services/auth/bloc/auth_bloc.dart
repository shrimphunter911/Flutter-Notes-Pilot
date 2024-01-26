import 'package:bloc/bloc.dart';
import 'package:pnotes/services/auth/auth_provider.dart';
import 'package:pnotes/services/auth/bloc/auth_events.dart';
import 'package:pnotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized(isLoading: true)) {
    // verification
    on<AuthEventSendEmailVerification>((event, email) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(exception: null, isLoading: false),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false,));
      }
    });
    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(exception: null, isLoading: true, loadingText: 'Please wait'),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
            email: email,
            password: password
        );
        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false)
          );
          emit(AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false)
          );
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    // register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.createUser(
            email: email,
            password: password
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        provider.logOut();
        emit(
          const AuthStateLoggedOut(exception: null, isLoading: false)
        );
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}