import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth/auth_bloc.dart';
import 'package:frontend/bloc/auth/auth_event.dart';
import 'package:frontend/bloc/auth/auth_state.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/widgets/auth/login_form.dart';

class LoginScreenMobile extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthController()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 650,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LoginForm.emailTextfield(email),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginForm.passwordTextfield(password),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginForm.submit(
                      'Submit',
                      onPressed: () {
                        context.read<AuthBloc>().add(LoginEvent(
                            email: email.text, password: password.text));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
