class Family {
  String? id;
  String? name;
  String? img;

  Family({this.id, this.name, this.img});

  Family.initial()
      : id = "-1",
        name = "",
        img = "";



  factory Family.fromJson(Map<String, dynamic> json) {

    String id = json["id"] ?? "";
    String name = json["name"] ?? "";
    String img = json["img"] ?? "";


    return Family(id:id, name: name, img: img);
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
