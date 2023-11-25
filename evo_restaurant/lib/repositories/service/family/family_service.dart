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


      if (listFamilies.isEmpty ) {
        ResponseObject responseObject = await _api.getFamilies();
        bool res = responseObject.status ?? false;
        if (res) {
          for (Family family in responseObject.responseObject as List<Family>) {
            int result = await SQLHelper.createFamily(
                family.id ?? "-1", family.name ?? "", family.img);
            print("Was inserted in the data base the family id: ${family.id}");
            if (result == 0) {
              throw "Something went wrong inserting family id: ${family.id},"
                  " in family_service.dart. Method: chargeFamiliesInDataBase";
            }
          }
          return Future.value(true);
        }
        throw "Something went wrong getting the families from the API. "
            "Error in family_service.dart method chargeFamiliesInDataBase";
      } else {
        //drop all data in the table and charge fresh data in the db
        for(Map<String, dynamic> element in listFamilies){
          if(element['id']!=null){
            print("--->>${element['id']}, ${element['name']}<<---");
          }
        }
        print("--->>Count: ${listFamilies.length} <<---");
        bool allFamiliesDrop = true;
        String failureId = "";
        for (Map<String, dynamic> element in listFamilies) {
          int res = 0;
          if(element['id'] != null){
          res = await SQLHelper.deleteFamily(element['id']);
          }

          //affected rows must be one
          if (res != 1 && element['id'] != null) {
            allFamiliesDrop = false;
            failureId = element["id"];
            break;
          }
        }
        if (!allFamiliesDrop) {
          //if it false means that was drop more than one row in the data base
          //that means something went wrong in the previous charge or was duplicated data
          throw "Something was wrong deleting the previous "
              "family id: $failureId,"
              " in family_service.dart in method chargeFamiliesInDataBase ";
        } else {
          //fill up the data base
          ///ToDo Remove this line, it was only use to check if the data base was erased
          List<Map<String, dynamic>> listFamilies = await SQLHelper.getFamilies();
          for(Map<String, dynamic> element in listFamilies){
            if(element['id']!=null){
              print("--->>${element['id']}, ${element['name']}<<---");
            }
          }
          print("--->>Count: ${listFamilies.length}  in delete families<<---");
          ///----------------------------------------------------------^^^^^^
          ResponseObject responseObject = await _api.getFamilies();
          bool res = responseObject.status ?? false;
          if (res) {
            for (Family family in responseObject.responseObject as List<Family>) {
              int result = await SQLHelper.createFamily(
                  family.id ?? "-1", family.name ?? "", family.img);
              print("Was inserted in the data base the family id: ${family.id}");
              if (result == 0) {
                throw "Something went wrong inserting family id: ${family.id}, "
                    "in family_service.dart. Method: chargeFamiliesInDataBase";
              }
            }
            print("--->>Count: ${(responseObject.responseObject as List<Family>).length}  in adding families<<---");
            return Future.value(true);
          }
          throw "Something went wrong getting the families from the API."
              " Error in family_service.dart method chargeFamiliesInDataBase";
        }
      }
    } catch (error) {
      print(
          "Error in family_service.dart. Error in Method chargeFamiliesInDataBase. Error: $error-------------->>>");
      return Future.value(false);
    }
  }
}
