

import 'package:flutter/material.dart';

class Article {
  int? id;
  String? name;
  String? img;
  String? fam;
  String? codBar;
  String? regIvaVta;
  int? pvp;
  bool? beb;
  Image? image;

  Article(
      {this.id,
      this.name,
      this.img,
      this.fam,
      this.codBar,
      this.regIvaVta,
      this.pvp,
      this.beb,
      this.image});

  Article.initial()
      : id = 0,
        name = "",
        img = "",
        fam = "",
        codBar = "",
        regIvaVta = "",
        pvp = 0,
        beb = false,
        image = null;

  factory Article.fromJson(Map<String, dynamic> json) {
    int id = json["id"] ?? 0;
    String name = json["name"] ?? "";
    String img = json["img"] ?? "";
    String fam = json["fam"] ?? "";
    String codBar = json["cod_bar"] ?? "";
    String regIvaVta = json["reg_iva_vta"] ?? "";
    int pvp = json["pvp"] ?? 0;
    bool beb = json[""] ?? false;

    return Article(
        id: id,
        name: name,
        img: img,
        fam: fam,
        codBar: codBar,
        regIvaVta: regIvaVta,
        pvp: pvp,
        beb: beb);
  }

  @override
  String toString() {
    return 'Article{id: $id, name: $name, img: $img, fam: $fam, codBar: $codBar, regIvaVta: $regIvaVta, pvp: $pvp, beb: $beb, image: $image}';
  }


}
