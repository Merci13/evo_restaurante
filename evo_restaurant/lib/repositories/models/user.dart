class User {
  int? id;
  String? name;
  String? userLastName;

  bool? isLogged;

  User({
    this.id,
    this.name,
    this.userLastName,
  });

  User.initial()
      : id = -1,
        name = "",
        userLastName = "",
        isLogged = false;

  @override
  String toString() {
    return 'User{id: $id,'
        ' name: $name,'
        ' userLastName: $userLastName,'
        ' isLogged: $isLogged'
        '}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    int? id = json['ID'] ?? -1;
    String? userLastName = json['USR_LAST_NAME'] ?? '';
    String? userName = json['USR_NAME'] ?? '';

    return User(
      id: id,
      name: userName,
      userLastName: userLastName,
    );
  }

  String toJson() {
    return "{"
        "\"id\": \"$id\","
        "\"name\": \"$name\","
        "\"userLastName\": \"$userLastName\""
        "}";
  }

  bool isEmpty() {
    if (id == null && id == -1) {
      return true;
    }
    return false;
  }
}
