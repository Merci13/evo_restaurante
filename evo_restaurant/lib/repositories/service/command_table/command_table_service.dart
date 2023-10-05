

import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';

class CommandTableService{

  late ApiSource _apiSource;

  set apiSource(ApiSource value) {
    _apiSource = value;
  }

  Future<ResponseObject> getCommand() async{
    return await _apiSource.getTable(tableGet)

  }


}