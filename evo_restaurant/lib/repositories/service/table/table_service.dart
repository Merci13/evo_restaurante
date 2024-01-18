



import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/command_table.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';

class TableService {
  late ApiSource _apiSource;

  set apiSource(ApiSource value) {
    _apiSource = value;
  }

  Future<ResponseObject> sendCommand(List<CommandTable> listOfCommand, String idTable) async {
    return await _apiSource.senCommand(listOfCommand, idTable);

  }




}