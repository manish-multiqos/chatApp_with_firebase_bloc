part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthStart extends AuthEvent {
  final Myuser user;
  final BuildContext context;

  AuthStart(this.user, this.context);
}

class AuthSubmitOtp extends AuthEvent {
  final String otp;
  final Myuser user;

  AuthSubmitOtp(this.otp, this.user);
}

class AuthCheck extends AuthEvent {}

class AuthAutoVerificaton extends AuthEvent {
  final AuthCredential credential;
  final Myuser user;
  AuthAutoVerificaton(this.credential, this.user);
}
