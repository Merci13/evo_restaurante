



import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';

class FamilyService{
  late ApiSource _api;

  set api(ApiSource value) {
    _api = value;
  }

  Future<ResponseObject> getFamilies() async{
    return await _api.getFamilies();
  }

  Future<ResponseObject> getArticlesOfFamily(Family family) async{
    return await _api.getArticlesOfFamily(family);
  }


}