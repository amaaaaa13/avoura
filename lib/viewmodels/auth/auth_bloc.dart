// ignore_for_file: unused_local_variable

import 'package:avoura/core/services/auth_services.dart';
import 'package:avoura/viewmodels/auth/auth_event.dart';
import 'package:avoura/viewmodels/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<SignUpWithEmailEvent>(_onSignUpWithEmail); // Register the handler here
  }

  // Handle login with email and password
  Future<void> _onLoginWithEmail(
      LoginWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.loginWithEmail(event.email, event.password);
      emit(AuthSuccess("Login Successful")); // Emit success state
    } catch (e) {
      emit(AuthFailure("Failed to log in: ${e.toString()}")); // Emit failure state
    }
  }

  // Handle Google sign-in
  Future<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    try {
      final result = await authService.continueWithGoogle();
      emit(AuthSuccess("Google Login Successful")); // Emit success state
    } catch (e) {
      emit(AuthFailure("Failed to log in with Google: ${e.toString()}")); // Emit failure state
    }
  }

  // Handle sign-up with email and password
  Future<void> _onSignUpWithEmail(
      SignUpWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result =
          await authService.createAccountWithEmail(event.email, event.password);
      emit(AuthSuccess("Account Created Successfully")); // Emit success state
    } catch (e) {
      emit(AuthFailure("Failed to sign up: ${e.toString()}")); // Emit failure state
    }
  }
}