import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInEvent extends AuthEvent {}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
