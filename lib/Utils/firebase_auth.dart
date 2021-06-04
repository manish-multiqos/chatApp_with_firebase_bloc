import 'package:chatapp/Config/context.dart';
import 'package:chatapp/Models/user_model.dart';
import 'package:chatapp/bloc/Auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseAuthentication {
  String verificationID;

  Future<UserCredential> verifyPhone(Myuser user, BuildContext context) async {
    UserCredential result;
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      BlocProvider.of<AuthBloc>(context)
          .add(AuthAutoVerificaton(authResult, user));
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print(authException.message);
      showSnackBar(authException.message, Colors.red, context);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      verificationID = verId;
      print(verificationID);
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationID = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91 ${user.number}",
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
    return result;
  }

  Future<UserCredential> signInOtp(AuthCredential authCreds) async {
    return await FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  Future<UserCredential> signInWithOTP(String smsCode) async {
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);
    print(authCreds);
    return await signInOtp(authCreds);
  }
}
