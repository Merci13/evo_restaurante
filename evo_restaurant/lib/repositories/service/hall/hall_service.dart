

import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';

class HallService{

  late ApiSource _api;

  set api(ApiSource value) {
    _api = value;
  }

 Future<ResponseObject> getAllHalls()async {
    return await _api.getAllHalls();

  }




}