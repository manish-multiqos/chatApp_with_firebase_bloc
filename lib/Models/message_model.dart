class Message {
  String message;
  String timestamp;
  String idFrom;
  String idTo;
  String chatId;

  Message({this.idFrom, this.idTo, this.message, this.timestamp, this.chatId});

  factory Message.fromJson(json) {
    return Message(
        idFrom: json["idFrom"],
        idTo: json["idTo"],
        message: json["message"],
        timestamp: json["timestamp"],
        chatId: json["chatId"]);
  }

  Map<String, dynamic> toMap() => {
        "idFrom": this.idFrom,
        "idTo": this.idTo,
        "message": this.message,
        "timestamp": this.timestamp,
        "chatId": this.chatId
      };
}
