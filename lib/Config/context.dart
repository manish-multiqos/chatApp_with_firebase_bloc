import 'package:chatapp/UI/LoginScreen.dart';
import 'package:chatapp/Utils/SharedManager.dart';
import 'package:flutter/material.dart';

showSnackBar(String title, Color color, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    ),
  );
}

showLogoutDialog(BuildContext context) {
  Widget cancelButton = TextButton(
    child: Text("Logout"),
    onPressed: () async {
      await SharedManager.logout();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (ctx) => LoginScreen()), (route) => false);
    },
  );
  Widget continueButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Are you sure"),
    content: Text("Do you want to Logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
