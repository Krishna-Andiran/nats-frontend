import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth/auth_event.dart';
import 'package:frontend/bloc/auth/auth_state.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/widgets/components.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthController _authController;
  AuthBloc(AuthController authController)
      : _authController = authController,
        super(InitialState()) {
    on<LoginEvent>(_login);
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    Components.logMessage("Login Bloc");
    try {
      emit(InitialState());
      final success = await _authController.login(event.email, event.password);
      if (success) {
        Components.logMessage("Login Bloc Success");
        // await Future.delayed(const Duration(seconds: 2));
        emit(SuccessState());
      }
    } catch (error) {
      Components.logErrMessage("Bloc Failed to Login", error.toString());
      emit(FailedState(error: error.toString()));
    }
  }
}
