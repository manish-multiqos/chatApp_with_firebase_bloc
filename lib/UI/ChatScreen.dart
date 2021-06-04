import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Utils/SharedManager.dart';
import 'package:chatapp/Utils/firebase_function.dart';
import 'package:chatapp/widgets/msg_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/user_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Myuser user;
  final String groupchatID;
  final String number;

  ChatScreen({this.user, this.groupchatID, this.number});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String number;

  List<DocumentSnapshot> listMessage = new List.from([]);
  TextEditingController textEditingController = TextEditingController();
  int _limit = 20;
  String groupChatId = "";
  final ScrollController listScrollController = ScrollController();
  final int _limitIncrement = 20;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    widget.groupchatID != null ? getData() : readLocal();
  }

  getData() {
    groupChatId = widget.groupchatID;
    number = widget.number;
  }

  readLocal() async {
    // for new chat (no coneversation stared)
    // generate chat id
    number = await SharedManager.getUserNumber();
    print("number: ${widget.user.number}");
    if (number.hashCode <= widget.user.number.hashCode) {
      groupChatId = '$number-${widget.user.number}';
    } else {
      groupChatId = '${widget.user.number}-$number';
    }
    setState(() {});
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      Message message = Message(
          chatId: groupChatId,
          idFrom: number,
          idTo: widget.user.number,
          message: content,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFunction.sendMassage(message);
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  _scrollListener() {
    // get position of screen in chat
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        print("reach the top");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        print("reach the bottom");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          widget.user.name,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            buildListMessage(),
            _sendMessageField(),
          ],
        ),
      ),
    );
  }

  Widget buildListMessage() {
    // show messages that had made if any
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: groupChatId == ''
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: FirebaseFunction.getMessage(groupChatId, _limit),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    listMessage.addAll(snapshot.data.docs);
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        print(snapshot.data.docs.first.data());
                        Message message =
                            Message.fromJson(snapshot.data.docs[index]);

                        return MessageDetails(
                          message: message,
                          number: number,
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ),
      ),
    );
  }

  _sendMessageField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              maxLines: 5,
              minLines: 1,
              controller: textEditingController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              onSendMessage(textEditingController.text);
            },
          ),
        ],
      ),
    );
  }
}
