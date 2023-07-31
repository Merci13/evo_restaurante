import 'dart:convert';

import 'package:evo_restaurant/repositories/models/command_table.dart';

class TableDetail {
  int? count;
  int? totalCount;
  List<CommandTable>? commandTable = List.empty(growable: true);//this CommandTable is the "fac_apa_lin_t" space in the json

  TableDetail({this.count, this.totalCount, this.commandTable});

  TableDetail.initial()
      : count = 0,
        totalCount = 0,
        commandTable = List.empty(growable: true);

  factory TableDetail.fromJson(Map<String, dynamic> json) {
    int? count = json["count"] ?? 0;
    int? totalCount = json["total_count"] ?? 0;

    List<dynamic> temp = json["fac_apa_lin_t"];
    List<CommandTable> command = List.empty(growable: true);

    for (var element in temp) {
      command.add(CommandTable.fromJson(element));
    }

    return TableDetail(
        count: count,
        totalCount: totalCount,
        commandTable: command);
  }

  @override
  String toString() {
    return 'TableDetail{count: $count, totalCount: $totalCount, tableDetail: $commandTable}';
  }
}
