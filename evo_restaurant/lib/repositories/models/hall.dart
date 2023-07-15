class Hall {
  int? id;
  String? emp;
  String? empDiv;
  String? name;

  Hall({this.id, this.emp, this.empDiv, this.name});

  Hall.initial()
      : id = 0,
        emp = "",
        empDiv = "",
        name = "";

  factory Hall.fromJson(Map<String, dynamic> json) {
    int id = json["id"] ?? 0;
    String emp = json["emp"] ?? "";
    String empDiv = json["emp_div"] ?? "";
    String name = json["name"] ?? "";

    return Hall(id: id, empDiv: empDiv, emp: emp, name: name);
  }

  @override
  String toString() {
    return 'Hall{id: $id, emp: $emp, empDiv: $empDiv, name: $name}';
  }
}
