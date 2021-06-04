import 'dart:io';

class Myuser {
  String number;
  String name;
  String imageUrl;
  File fileImg;

  Myuser({this.number, this.name, this.imageUrl, this.fileImg});

  factory Myuser.fromJson(Map user) {
    return Myuser(
        name: user["name"], number: user["number"], imageUrl: user["imageUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "number": this.number,
      "imageUrl": this.imageUrl
    };
  }
}
