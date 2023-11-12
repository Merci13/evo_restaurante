import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/utils/db/sql_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FamilyService {
  late ApiSource _api;
  late SQLHelper _sqlHelper;

  set api(ApiSource value) {
    _api = value;
  }

  set sqlHelper(SQLHelper value) {
    _sqlHelper = value;
  }

  Future<ResponseObject> getFamilies() async {
    return await _api.getFamilies();
  }

  Future<ResponseObject> getArticlesOfFamily(Family family) async {
    return await _api.getArticlesOfFamily(family);
  }

  Future<bool> chargeFamiliesInDataBase() async {
    try {

      List<Map<String, dynamic>> listFamilies = await SQLHelper.getFamilies();
      if(listFamilies.isEmpty){
        ResponseObject responseObject = await _api.getFamilies();
        bool res = responseObject.status ?? false;
        if(res){
          

        }
        return Future.value(false);
      }


    } catch (error) {
      print(
          "Error in family_service.dart. Error in Method chargeFamiliesInDataBase. Error: $error-------------->>>");
    return Future.value(false);
    }
  }
}
