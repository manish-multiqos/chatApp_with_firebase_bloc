import 'package:bubble/bubble.dart';
import 'package:chatapp/Models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageDetails extends StatelessWidget {
  final Message message;
  final String number;
  MessageDetails({this.message, this.number});
  @override
  Widget build(BuildContext context) {
    print(message.message);
    return Row(
      mainAxisAlignment: message.idFrom == number
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: <Widget>[
        Bubble(
          margin: message.idFrom == number
              ? BubbleEdges.only(right: 10.0, bottom: 10.0)
              : BubbleEdges.only(left: 10.0, bottom: 10.0),
          padding: BubbleEdges.fromLTRB(10.0, 8.0, 10.0, 8.0),
          nip:
              message.idFrom == number ? BubbleNip.rightTop : BubbleNip.leftTop,
          color: message.idFrom == number ? Colors.cyan[50] : Colors.grey[50],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(bottom: 3),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    message.message,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                DateFormat('Hm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(
                      message.timestamp,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
