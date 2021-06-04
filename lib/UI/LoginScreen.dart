import 'dart:io';

import 'package:chatapp/Config/context.dart';
import 'package:chatapp/Models/user_model.dart';
import 'package:chatapp/UI/OtpScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final nameController = TextEditingController();
  final numberController = TextEditingController();

  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  _circleImage(),
                  _nameField(),
                  _phoneNumberField(),
                  _loginButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleImage() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          _getImageFromGallary(),
          _getImageFromCamera(),
        ],
      ),
    );
  }

  Widget _getImageFromGallary() {
    return GestureDetector(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: image == null
                  ? AssetImage("assets/images/greg.jpg")
                  : FileImage(image)),
        ),
      ),
      onTap: () => getImage(ImageSource.gallery),
    );
  }

  Widget _getImageFromCamera() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        child: CircleAvatar(
          radius: 15,
          child: Icon(
            Icons.camera,
          ),
        ),
        onTap: () => getImage(ImageSource.camera),
      ),
    );
  }

  Widget _nameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: "Name",
          hintStyle: TextStyle(color: Colors.grey),
        ),
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Please Enter Name";
          } else
            return null;
        },
      ),
    );
  }

  Widget _phoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: numberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: "Phone number",
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        validator: (value) {
          if (value.trim().isEmpty || value.trim().length != 10) {
            return "Please Enter Valid Phone Number";
          } else
            return null;
        },
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: MaterialButton(
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8)),
          color: Theme.of(context).primaryColor,
          height: 50,
          minWidth: double.infinity,
          child: Text(
            "LOGIN",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () {
            login();
          }),
    );
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile =
        await picker.getImage(source: source, maxHeight: 200, maxWidth: 200);

    if (pickedFile != null) {
      if (image != null) await image.delete(recursive: true);
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void login() async {
    if (_formKey.currentState.validate() && image != null) {
      final user = Myuser(
          name: nameController.text,
          number: numberController.text,
          fileImg: image);
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => OtpPage(user: user)));
    } else {
      showSnackBar("Please Enter All Details", Colors.red, context);
    }
  }
}
