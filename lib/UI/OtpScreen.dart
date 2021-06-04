import 'package:chatapp/Config/context.dart';
import 'package:chatapp/Models/user_model.dart';
import 'package:chatapp/UI/HomeScreen.dart';
import 'package:chatapp/bloc/Auth/auth_bloc.dart';
import 'package:chatapp/widgets/otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatefulWidget {
  final Myuser user;
  OtpPage({this.user});
  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  TextEditingController otpController = new TextEditingController();
  Size size;
  String verificationId;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      BlocProvider.of<AuthBloc>(context).add(AuthStart(widget.user, context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showSnackBar("Welcome", Colors.green, context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => HomeScreen(state.number)),
              (route) => false);
        } else if (state is AuthFailure) {
          showSnackBar(state.msg, Colors.red, context);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: appBar(),
              backgroundColor: Colors.white,
              body: Container(
                padding: EdgeInsets.all(25),
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[otpBox(), button()],
                ),
              ),
            ),
            Visibility(visible: state is AuthLoding, child: loder())
          ],
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "Verification",
        style: TextStyle(color: Colors.black),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget otpBox() {
    return Column(
      children: <Widget>[
        Text(
          "We have sent 6 digit code on",
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "+91 ${widget.user.number}",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _otpField(size),
        Text("Didn't you received code?"),
        OtpTimer(() {
          BlocProvider.of<AuthBloc>(context)
              .add(AuthStart(widget.user, context));
        })
      ],
    );
  }

  Widget button() {
    return MaterialButton(
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8)),
        color: Theme.of(context).primaryColor,
        height: 50,
        minWidth: size.width * 0.9,
        child: Text(
          "Continue",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        onPressed: () {
          BlocProvider.of<AuthBloc>(context)
              .add(AuthSubmitOtp(otpController.text, widget.user));
        });
  }

  Widget _otpField(Size size) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          obscureText: false,
          obscuringCharacter: '*',
          blinkWhenObscuring: true,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              activeColor: Colors.grey,
              disabledColor: Colors.grey,
              inactiveColor: Colors.grey,
              selectedColor: Theme.of(context).primaryColor),
          cursorColor: Colors.black,
          animationDuration: Duration(milliseconds: 300),
          controller: otpController,
          keyboardType: TextInputType.number,
          onCompleted: (v) {
            print("Completed");
          },
          onChanged: (value) {},
          beforeTextPaste: (text) {
            print("Allowing to paste $text");

            return true;
          },
        ));
  }

  Widget loder() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
