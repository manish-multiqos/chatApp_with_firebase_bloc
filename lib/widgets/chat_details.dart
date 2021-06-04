import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDetails extends StatelessWidget {
  final Message message;
  final Myuser user;
  ChatDetails({this.user, this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                  radius: 30.0,
                  backgroundImage: user.imageUrl.isEmpty
                      ? AssetImage("assets/images/greg.jpg")
                      : NetworkImage(user.imageUrl)),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  message == null
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            message.message,
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ],
              ),
            ],
          ),
          message == null
              ? Container()
              : Text(
                  DateFormat('Hm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(
                        message.timestamp,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}
