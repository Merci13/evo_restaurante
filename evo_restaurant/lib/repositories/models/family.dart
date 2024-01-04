import 'package:flutter/widgets.dart';


///
/// Family
///   String? id;
///   String? name;
///   String? img;
///   Image? image;
///
class Family {
  String? id;
  String? name;
  String? img;
  Image? image;

  Family({this.id, this.name, this.img, this.image});

  Family.initial()
      : id = "-1",
        name = "",
        img = "",
        image = null
  ;



  factory Family.fromJson(Map<String, dynamic> json) {

    String id = json["id"] ?? "";
    String name = json["name"] ?? "";
    String img = json["img"] ?? "";


    return Family(id:id, name: name, img: img, image: null);
  }

  String toJson() {
    return "{"
        "\"id\": \"$id\","
        "\"name\": \"$name\","
        "\"img\": \"$img\""
        "}";
  }

  @override
  String toString() {
    return 'Family{id: $id, name: $name, img: $img}';
  }
}
