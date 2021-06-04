import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/Models/user_model.dart';
import 'package:chatapp/Utils/SharedManager.dart';
import 'package:chatapp/Utils/firebase_auth.dart';
import 'package:chatapp/Utils/firebase_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  FirebaseAuthentication _fireAuth = FirebaseAuthentication();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    // initiate authentication

    if (event is AuthStart) {
      await _fireAuth.verifyPhone(event.user, event.context);
    }
    // auto auth without enter otp
    // this will only works when user using same number in same mobile

    if (event is AuthAutoVerificaton) {
      final result = await _fireAuth.signInOtp(event.credential);

      if (result?.user != null) {
        yield AuthLoding();
        await SharedManager.setUserNumber(event.user.number);
        await FirebaseFunction.setUserDetails(event.user);
        yield AuthSuccess(event.user.number);
      }
    }

    // when user open the app it will check is already login or not

    if (event is AuthCheck) {
      var number = await SharedManager.getUserNumber();
      if (number.isNotEmpty) {
        yield AuthSuccess(number);
      } else
        yield AuthFailure();
    }

    // when user enter otp and then click submit button

    if (event is AuthSubmitOtp) {
      yield AuthLoding();
      try {
        UserCredential result = await _fireAuth.signInWithOTP(event.otp);
        if (result?.user != null) {
          // set user number in local storage(chache)
          await SharedManager.setUserNumber(event.user.number);
          // set user details in database
          await FirebaseFunction.setUserDetails(event.user);
          yield AuthSuccess(event.user.number);
        } else {
          yield AuthFailure();
        }
      } on FirebaseAuthException catch (e) {
        print("erro ${e.message}");
        if (e.code == "invalid-verification-code") {
          yield AuthFailure(msg: "Invalid Otp");
        } else if (e.message == null) {
          yield AuthFailure();
        } else
          yield AuthFailure(msg: e.message);
      }
    }
  }
}
