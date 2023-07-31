import 'package:flutter/material.dart';

class SubFamily {
  String? id;
  String? name;
  String? img;
  Image? image;

  SubFamily({this.id, this.name, this.img, this.image});

  SubFamily.initial()
      : id = "",
        name = "",
        img = "",
        image = null;

  factory SubFamily.fromJson(Map<String, dynamic> json) {
    String id = json["id"] ?? "";
    String name = json["name"] ?? "";
    String img = json["img"] ?? "";

    return SubFamily(id: id, name: name, img: img, image: null);
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
    return 'SubFamily{id: $id, name: $name, img: $img}';
  }
}
