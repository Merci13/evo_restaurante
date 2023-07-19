class Table {
  int? id; //  Id:Idenficador del registro
  String? name; //   Name: Nombre de la mesa
  int? num; //  Num:Numero que identifica la mesa
  bool? est; // Est:Estado de la mesa 1 ocupada, 0 libre
  int? sal; //   Sal: Salon
  int? dept; //  dep_t : Mesero
  int? tot; //   Tot: Total de consumo de la mesa
  String? modTim; //   mod_tim: Ultimo cambio sobre la mesa

  Table(
      {this.id,
      this.name,
      this.num,
      this.est,
      this.sal,
      this.dept,
      this.tot,
      this.modTim});

  Table.initial()
      : id = 0,
        name = "",
        num = 0,
        est = false,
        sal = 0,
        dept = 0,
        tot = 0,
        modTim = "";


  factory Table.fromJson(Map<String, dynamic> json) {
    int id = json["id"] ?? 0;
    String name= json["name"] ?? "";
    int num= json["num"] ?? 0;
    bool est= json["est"] == 0 ? false : true;
    int sal= json["sal"] ?? 0;
    int dept= json["dep_t"] ?? 0;
    int tot= json["tot"] ?? 0;
    String modTim= json["mod_tim"] ?? "";

    return Table(
        id : id,
        name : name,
        num : num,
        est : est,
        sal : sal,
        dept : dept,
        tot : tot,
        modTim : modTim
    );
  }



}
