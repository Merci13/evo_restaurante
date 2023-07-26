import 'dart:convert';

import 'package:evo_restaurant/repositories/models/command_table.dart';

class TableDetail {
  int? count;
  int? totalCount;
  CommandTable? commandTable;

  TableDetail({this.count, this.totalCount, this.commandTable});

  TableDetail.initial()
      : count = 0,
        totalCount = 0,
        commandTable = CommandTable();

  factory TableDetail.fromJson(Map<String, dynamic> json) {
    int? count = json["count"] ?? 0;
    int? totalCount = json["total_count"] ?? 0;

    List<dynamic> temp
    CommandTable? commandTable = CommandTable.fromJson(
      jsonDecode(
        (json["fac_apa_lin_t"] ?? ""),
      ),
    ); //this CommandTable is the "fac_apa_lin_t" space in the json

    return TableDetail(
        count: count,
        totalCount: totalCount,
        commandTable: commandTable);
  }

  @override
  String toString() {
    return 'TableDetail{count: $count, totalCount: $totalCount, tableDetail: $commandTable}';
  }
}
