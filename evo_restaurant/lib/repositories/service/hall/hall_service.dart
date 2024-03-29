

import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/hall.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/models/table.dart';

class HallService{

  late ApiSource _api;

  set api(ApiSource value) {
    _api = value;
  }

 Future<ResponseObject> getAllHalls()async {
    return await _api.getAllHalls();

  }

  Future<ResponseObject> getAllTables(Hall hall)async {
    return await _api.getAllTablesFromHall(hall);


  }

  Future<ResponseObject> getTable(Table table)async {
    return await _api.getTable(table);
  }




}