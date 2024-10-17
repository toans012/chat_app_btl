import 'package:chat_customer/api/apis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onSignInRequested(
      SignInRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await APIs.auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthenticationAuthenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
      emit(AuthenticationUnauthenticated());
    }
  }

  void _onSignUpRequested(
      SignUpRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await APIs.auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await APIs.createUser();

      emit(AuthenticationAuthenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
      emit(AuthenticationUnauthenticated());
    }
  }

  void _onSignOutRequested(
      SignOutRequested event, Emitter<AuthenticationState> emit) async {
    await APIs.auth.signOut();
    emit(AuthenticationUnauthenticated());
  }
}
