import 'package:chatapp/Models/user_model.dart';
import 'package:chatapp/UI/ChatScreen.dart';
import 'package:chatapp/Utils/firebase_function.dart';
import 'package:chatapp/widgets/chat_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContectScreen extends StatelessWidget {
  final number;
  ContectScreen(this.number);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contects"),
      ),
      body: StreamBuilder(
        stream: FirebaseFunction.getTotalUser(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Myuser user = Myuser.fromJson(snapshot.data.docs[index].data());
                print(user.number);
                return number == user.number
                    ? Container()
                    : GestureDetector(
                        child: ChatDetails(
                          user: user,
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ChatScreen(
                                      user: user,
                                    ))),
                      );
              });
        },
      ),
    );
  }
}
