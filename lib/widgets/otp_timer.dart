import 'dart:async';

import 'package:flutter/material.dart';

class OtpTimer extends StatefulWidget {
  final Function onTap;

  OtpTimer(this.onTap);
  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  int count = 0;
  Timer timer;
  @override
  void initState() {
    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    count = 60;
    timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (count < 1) {
            timer.cancel();
          } else {
            count = count - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return count == 0
        ? TextButton(
            onPressed: () {
              startTimer();
              widget.onTap();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Resend OTP",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                ),
              ),
            ))
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Resend otp in $count secs",
              style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
              ),
            ),
          );
  }
}
