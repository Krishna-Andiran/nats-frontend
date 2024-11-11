import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class InitialState extends AuthState {}

class SuccessState extends AuthState {}

class FailedState extends AuthState {
  final String error;
  const FailedState({required this.error});
  
  @override
  List<Object?> get props => [error];
}
