part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final String number;
  AuthSuccess(this.number);
}

class AuthLoding extends AuthState {}

class AuthFailure extends AuthState {
  final String msg;
  AuthFailure({this.msg = "Something went wrong please try again"});
}
