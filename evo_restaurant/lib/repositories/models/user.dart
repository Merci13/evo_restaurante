class User {
  int? id;
  String? emp;
  String? empDiv;
  String? name;
  bool? supDep;
  String? pwd;

  bool? isLogged;

  User(
      {this.id,
      this.emp,
      this.empDiv,
      this.name,
      this.supDep,
      this.pwd,
      this.isLogged});

  User.initial()
      : id = -1,
        emp = "",
        empDiv = "",
        name = "",
        supDep = false,
        pwd = "",
        isLogged = false;

  @override
  String toString() {
    return 'User{id: $id, '
        'emp: $emp, '
        'empDiv: $empDiv, '
        'name: $name, '
        'supDep: $supDep, '
        'pwd: $pwd, '
        'isLogged: $isLogged}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    int? id = json['id'] ?? -1;
    String? emp = json['emp'] ?? '';
    String? empDiv = json['emp_div'] ?? '';
    String? name = json["name"] ?? '';
    String? pwd = json["pwd"] ?? '';
    bool? supDep = json["sup_dep"] ?? '';

    return User(
        id: id,
        emp: emp,
        empDiv : empDiv,
        name : name,
        pwd : pwd,
        supDep : supDep,
      isLogged: false
    );
  }

  String toJson() {
    return "{"
        "\"id\": \"$id\","
        "\"name\": \"$name\","
        "\"emp\": \"$emp\","
        "\"emp_div\": \"$empDiv\","
        "\"sup_dep\": \"$supDep\","
        "}";
  }

  bool isEmpty() {
    if (id == null && id == -1) {
      return true;
    }
    return false;
  }
}
