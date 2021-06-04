import 'package:chatapp/Config/context.dart';
import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Models/user_model.dart';
import 'package:chatapp/UI/ContectsScreen.dart';
import 'package:chatapp/UI/ChatScreen.dart';
import 'package:chatapp/Utils/firebase_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/chat_details.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String number;
  HomeScreen(this.number);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String groupChatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _appBar(),
      body: widget.number != null ? _body() : Container(),
      floatingActionButton: flotingButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.logout),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          showLogoutDialog(context);
        },
      ),
      title: Text(
        'Chats',
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _body() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      child: StreamBuilder(
        //  get user chat list and fetch chat id,last msg and time
        stream: FirebaseFunction.getUserChatList(widget.number),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Message message =
                    Message.fromJson(snapshot.data.docs[index].data());
                return StreamBuilder(
                    // get user details by his number to show reciver image and name
                    stream: FirebaseFunction.getUserData(
                        message.idFrom != widget.number
                            ? message.idFrom
                            : message.idTo),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      Myuser user = Myuser.fromJson(snapshot.data.data());
                      return GestureDetector(
                        child: ChatDetails(
                          user: user,
                          message: message,
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ChatScreen(
                                      user: user,
                                      groupchatID: message.chatId,
                                      number: widget.number,
                                    ))),
                      );
                    });
              },
            );
          }
        },
      ),
    );
  }

  Widget flotingButton() {
    // show all users
    return FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => ContectScreen(widget.number))));
  }
}
