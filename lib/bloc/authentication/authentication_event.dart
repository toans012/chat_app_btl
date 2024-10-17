import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;

  const SignUpRequested(this.name, this.email, this.password);
}

class SignOutRequested extends AuthenticationEvent {}
