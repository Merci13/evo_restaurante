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

  static toJson(List<CommandTable> listOfCommand) {
    String temp = "{ \"items\": [";

    for (int i = 0; i < listOfCommand.length; i++) {
      String val = "{";
      if (i+1 == listOfCommand.length) {
        val += "\"id\": ${listOfCommand[i].id},"
            " \"idLin\": ${listOfCommand[i].idLin},"
            " \"idArt\": ${listOfCommand[i].idArt},"
            " \"name\": \"${listOfCommand[i].name}\","
            " \"can\": ${listOfCommand[i].can},"
            " \"pre\": ${listOfCommand[i].pre},"
            " \"porDto\": ${listOfCommand[i].porDto},"
            " \"preNet\": ${listOfCommand[i].preNet},"
            " \"imp\": ${listOfCommand[i].imp},"
            " \"porIva\": ${listOfCommand[i].porIva},"
            " \"mesT\": ${listOfCommand[i].mesT},"
            " \"depT\": ${listOfCommand[i].depT},"
            " \"cBar\": \"${listOfCommand[i].cBar}\","
            " \"fec\": \"${listOfCommand[i].fec}\""
            "}]}";
      } else {
        val += "\"id\": ${listOfCommand[i].id},"
            " \"idLin\": ${listOfCommand[i].idLin},"
            " \"idArt\": ${listOfCommand[i].idArt},"
            " \"name\": \"${listOfCommand[i].name}\","
            " \"can\": ${listOfCommand[i].can},"
            " \"pre\": ${listOfCommand[i].pre},"
            " \"porDto\": ${listOfCommand[i].porDto},"
            " \"preNet\": ${listOfCommand[i].preNet},"
            " \"imp\": ${listOfCommand[i].imp},"
            " \"porIva\": ${listOfCommand[i].porIva},"
            " \"mesT\": ${listOfCommand[i].mesT},"
            " \"depT\": ${listOfCommand[i].depT},"
            " \"cBar\": \"${listOfCommand[i].cBar}\","
            " \"fec\": \"${listOfCommand[i].fec}\"},";
      }
      temp += val;
    }
    return temp ;
  }

  static toJsonLine(CommandTable commandTable) {
    String val = "{\"id\": ${commandTable.id},"
        " \"idLin\": ${commandTable.idLin},"
        " \"idArt\": ${commandTable.idArt},"
        " \"name\": \"${commandTable.name}\","
        " \"can\": ${commandTable.can},"
        " \"pre\": ${commandTable.pre},"
        " \"porDto\": ${commandTable.porDto},"
        " \"preNet\": ${commandTable.preNet},"
        " \"imp\": ${commandTable.imp},"
        " \"porIva\": ${commandTable.porIva},"
        " \"mesT\": ${commandTable.mesT},"
        " \"depT\": ${commandTable.depT},"
        " \"cBar\": \"${commandTable.cBar}\","
        " \"fec\": \"${commandTable.fec}\""
        "}";
    return val;
  }
}
