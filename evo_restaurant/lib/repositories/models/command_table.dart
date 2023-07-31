class CommandTable {
  int? id; //Idenficador del registro

  int? idLin; // Identificar el numero de la línea,

  int? idArt; //Edificador de la artículo,

  String? name; // Nombre del artículo,

  int? can; // Cantidad,

  int? pre; //Precio del artículo,

  int? porDto; //descuento se deja en 0,

  int? preNet; //se deja en 0,

  int? imp; //Total de la linea

  int? porIva; // porcentaje IVA del articulo sale de la tabla art_m,

  int? mesT; //identificar de la mesa,

  int? depT; // identificador del mesero,

  int? cBar; //código de barra del artículo,

  String? fec; //fecha del registro ejemplo 2023-05-23T18:36:03.000Z

  CommandTable(
      {this.id,
      this.idLin,
      this.idArt,
      this.name,
      this.can,
      this.pre,
      this.porDto,
      this.preNet,
      this.imp,
      this.porIva,
      this.mesT,
      this.depT,
      this.cBar,
      this.fec});

  CommandTable.initial()
      : id = 0,
        idLin = 0,
        idArt = 0,
        name = "",
        can = 0,
        pre = 0,
        porDto = 0,
        preNet = 0,
        imp = 0,
        porIva = 0,
        mesT = 0,
        depT = 0,
        cBar = 0,
        fec = "";

  factory CommandTable.fromJson(Map<String, dynamic> json) {
    int? id = json["id"] ?? 0;
    int? idLin = json["id_lin"] ?? 0;
    int? idArt = json["id_art"] ?? 0;
    String? name = json["name"] ?? "";
    int? can = json["can"] ?? 0;
    int? pre = json["pre"] ?? 0;
    int? porDto = json["por_dto"] ?? 0;
    int? preNet = json["pre_net"] ?? 0;
    int? imp = json["imp"] ?? 0;
    int? porIva = json["por_iva"] ?? 0;
    int? mesT = json["mes_t"] ?? 0;
    int? depT = json["dep_t"] ?? 0;
    int? cBar = json["c_bar"] ?? 0;
    String? fec = json["fec"] ?? "";

    return CommandTable(
      id: id,
      idLin: idLin,
      idArt: idArt,
      name: name,
      can: can,
      pre: pre,
      porDto: porDto,
      preNet: preNet,
      imp: imp,
      porIva: porIva,
      mesT: mesT,
      depT: depT,
      cBar: cBar,
      fec: fec,
    );
  }

  @override
  String toString() {
    return 'CommandTable{id: $id, idLin: $idLin, idArt: $idArt, name: $name, can: $can, pre: $pre, porDto: $porDto, preNet: $preNet, imp: $imp, porIva: $porIva, mesT: $mesT, depT: $depT, cBar: $cBar, fec: $fec}';
  }
}
