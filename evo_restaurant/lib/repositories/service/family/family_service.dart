import 'dart:convert';

import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/global/error_codes.dart';
import 'package:evo_restaurant/repositories/models/article.dart';
import 'package:evo_restaurant/repositories/models/error_object.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/utils/db/sql_helper.dart';
import 'package:flutter/material.dart';


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
    //ask first if the bd has families, if not, ask to API
    List<Map<String, dynamic>> listFamilies = await SQLHelper.getFamilies();
    if (listFamilies.isNotEmpty) {
      List<Family> families = List.empty(growable: true);

      for (Map<String, dynamic> element in listFamilies) {
        if(element['id'] != null){
          Family family = Family.fromJson(element);

          family.image =  Image.memory(base64Decode(family.img ?? ""));

          families.add(family);
        }

      }
      return ResponseObject(
          responseObject: families, status: true, errorObject: null);
    } else {
      ResponseObject responseObject = await _api.getFamilies();
      bool res = responseObject.status ?? false;
      if (res) {
        for (Family family in responseObject.responseObject as List<Family>) {
          if((family.id??"").length <= 2){
            int result = await SQLHelper.createFamily(
                family.id ?? "-1", family.name ?? "", family.img);
            print("Was inserted in the data base the family id: ${family.id}");
            if (result == 0) {
              ResponseObject rest = ResponseObject(
                  status: false,
                  responseObject: null,
                  errorObject: ErrorObject(
                      status: false,
                      errorCode: errorChargingData,
                      errorMessage: "Something went wrong inserting family id: ${family.id},"
                          " in family_service.dart. Method: chargeFamiliesInDataBase",
                      errorObject: null,
                      message: ""
                  )
              );
              return rest;
            }
          }



        }
        return responseObject;
      }
      return responseObject;

    }
  }

  Future<ResponseObject> getArticlesOfFamily(Family family) async {
    //ask first if the bd has articles of that family if not, ask to API
    List<Map<String, dynamic>> listArticles =
        await SQLHelper.getArticlesByFamilyId(family.id ?? "");

    if (listArticles.isNotEmpty) {
      List<Article> articles = List.empty(growable: true);
      for (var element in listArticles) {
        Article article = Article.fromJson(element);
        article.image =  Image.memory(base64Decode(article.img ?? ""));
        articles.add(article);
      }

      return ResponseObject(
          responseObject: articles, status: true, errorObject: null);
    } else {
      return await _api.getArticlesOfFamily(family);
    }
  }

  Future<bool> chargeFamiliesInDataBase() async {
    try {
      List<Map<String, dynamic>> listFamilies = await SQLHelper.getFamilies();

      if (listFamilies.isEmpty) {
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
        for (Map<String, dynamic> element in listFamilies) {
          if (element['id'] != null) {
            print("--->>${element['id']}, ${element['name']}<<---");
          }
        }
        print("--->>Count: ${listFamilies.length} <<---");
        bool allFamiliesDrop = true;
        String failureId = "";
        for (Map<String, dynamic> element in listFamilies) {
          int res = 0;
          if (element['id'] != null) {
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
          List<Map<String, dynamic>> listFamilies =
              await SQLHelper.getFamilies();
          for (Map<String, dynamic> element in listFamilies) {
            if (element['id'] != null) {
              print("--->>${element['id']}, ${element['name']}<<---");
            }
          }
          print("--->>Count: ${listFamilies.length}  in delete families<<---");

          ///----------------------------------------------------------^^^^^^
          ResponseObject responseObject = await _api.getFamilies();
          bool res = responseObject.status ?? false;
          if (res) {
            for (Family family
                in responseObject.responseObject as List<Family>) {
              int result = await SQLHelper.createFamily(
                  family.id ?? "-1", family.name ?? "", family.img);
              print(
                  "Was inserted in the data base the family id: ${family.id}");
              if (result == 0) {
                throw "Something went wrong inserting family id: ${family.id}, "
                    "in family_service.dart. Method: chargeFamiliesInDataBase";
              }
            }
            print(
                "--->>Count: ${(responseObject.responseObject as List<Family>).length}  in adding families<<---");
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
