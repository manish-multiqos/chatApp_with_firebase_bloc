import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseFunction {
  static Future<void> setUserDetails(Myuser user) async {
    // set user details and upload image to firebase storege
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${user.number}.png');
    try {
      await ref.putFile(user.fileImg);
      user.imageUrl = await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }

    await FirebaseFirestore.instance.collection("user").doc(user.number).set(
        {"name": user.name, "number": user.number, "imageUrl": user.imageUrl});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMsg(
      String groupChatId) {
    // get last msg to show msg and time in chatList screen
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .limitToLast(1)
        .snapshots()
        .handleError((e) => print(e));
  }

  static sendMassage(Message message) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(message.chatId)
        .collection(message.chatId)
        .doc(message.timestamp);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, message.toMap());
    });

    // this is help to get user chat list and last msg
    // set message in own document

    FirebaseFirestore.instance
        .collection("perUserChatList")
        .doc(message.idFrom)
        .collection(message.idFrom)
        .doc(message.chatId)
        .set(message.toMap());

    // set message in reciver document
    FirebaseFirestore.instance
        .collection("perUserChatList")
        .doc(message.idTo)
        .collection(message.idTo)
        .doc(message.chatId)
        .set(message.toMap());
  }

  static getMessage(String chatID, int limit) {
    // get limit based message
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(chatID)
        .collection(chatID)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .handleError((e) => print(e));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTotalUser() {
    // all user
    return FirebaseFirestore.instance.collection('user').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatList(
      String number) {
    // get chatlist creted by one user
    return FirebaseFirestore.instance
        .collection('perUserChatList')
        .doc(number)
        .collection(number)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((e) => print(e));
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData(
      String number) {
    // get user details
    return FirebaseFirestore.instance
        .collection('user')
        .doc(number)
        .snapshots()
        .handleError((e) => print(e));
  }
}
