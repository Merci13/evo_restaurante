import 'dart:convert';

import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/global/error_codes.dart';
import 'package:evo_restaurant/repositories/models/article.dart';
import 'package:evo_restaurant/repositories/models/error_object.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/models/sub_family.dart';
import 'package:flutter/material.dart';

import '../../../utils/db/sql_helper.dart';

class SubFamilyService {
  late ApiSource _apiSource;

  set apiSource(ApiSource value) {
    _apiSource = value;
  }

  Future<ResponseObject> getSubfamily(Family family) async {
    //ask if the bd has data first, if it has, return it otherwise ask from the api

    List<Map<String, dynamic>> listOfSubfamilies =
    await SQLHelper.getSubFamiliesByIdOfFamily(family.id ?? "");
    if (listOfSubfamilies.isNotEmpty) {
      List<SubFamily> subfamilies = List.empty(growable: true);
      for (var element in listOfSubfamilies) {
        SubFamily subFamily = SubFamily.fromJson(element);
        subFamily.image = Image.memory(base64Decode(subFamily.img ?? ""));
        subfamilies.add(subFamily);
      }
      return ResponseObject(
        status: true,
        responseObject: subfamilies,
        errorObject: null,
      );
    } else {
      ResponseObject responseObject = await _apiSource.getSubfamily(family);

      if (!(responseObject.status ?? false)) {
        return ResponseObject(
            status: false,
            errorObject: ErrorObject(
              status: false,
              message: "Error in sub_family_service.dart in method chargeSubfamiliesInDataBase."
                  " Family id=${family.id ?? ""} don't have sub-families",
              errorCode: errorChargingData,
            ));
      }
      //if the family has sub-families
      else {
        String idFamily = family.id ?? "";
        List<SubFamily> temp = responseObject.responseObject as List<SubFamily>;
        if (temp.isNotEmpty) {
          //check if the db has subfamilies of the family and delete elements
          List<Map<String, dynamic>> listSubFamilies =
          await SQLHelper.getSubFamiliesByIdOfFamily(idFamily);
          bool allSubFamiliesDrop = true;
          String failureSubId = "";
          if (listSubFamilies.isNotEmpty) {
            //try to delete all elements in the data base
            for (Map<String, dynamic> elementSub in listSubFamilies) {
              int res = 0;
              if (elementSub['id'] != null) {
                res = await SQLHelper.deleteSubFamily(elementSub['id']);
              }
              //affected rows must be one
              if (res != 1 && elementSub['id'] != null) {
                allSubFamiliesDrop = false;
                failureSubId = elementSub["id"];
                break;
              }
            }
            if (!allSubFamiliesDrop) {
              //if it false means that was drop more than one row in the data base
              //that means something went wrong in the previous charge or was duplicated data

              return ResponseObject(
                  status: false,
                  errorObject: ErrorObject(
                    status: false,
                    message: "Something was wrong deleting the previous "
                        "family id: $failureSubId,"
                        " in sub_family_service.dart in method chargeSubfamiliesInDataBase",
                    errorCode: errorChargingData,
                  ));
            } else {
              //save sub-families
              List<SubFamily> subFamily =
              responseObject.responseObject as List<SubFamily>;
              for (SubFamily subFam in subFamily) {
                int i = await SQLHelper.createSubFamily(
                    idSubFamily: subFam.id ?? '',
                    idFamily: idFamily,
                    name: subFam.name ?? '',
                    img: subFam.img ?? '');
                if (i == 0) {
                  return ResponseObject(
                      status: false,
                      errorObject: ErrorObject(
                        status: false,
                        message: "Error in sub_family_service.dart"
                            " in method SQLHelper.createSubFamily for subfamily id=${subFam
                            .id ?? ''}. ",
                        errorCode: errorChargingData,
                      ));
                } else {
                  print(
                      "--->>>Subfamily was inserted, id =${subFam.id} <<<---");
                }
              }
              return responseObject;
            }
          } else {
            //save direct the sub-family
            //save sub-families
            List<SubFamily> subFamily = temp;
            for (SubFamily subFam in subFamily) {
              int i = await SQLHelper.createSubFamily(
                  idSubFamily: subFam.id ?? '',
                  idFamily: idFamily,
                  name: subFam.name ?? '',
                  img: subFam.img ?? '');
              if (i == 0) {
                //error
                return ResponseObject(
                    status: false,
                    errorObject: ErrorObject(
                      status: false,
                      message: "Error in sub_family_service.dart"
                          " in method SQLHelper.createSubFamily for subfamily id=${subFam
                          .id ?? ''}. ",
                      errorCode: errorChargingData,
                    ));
              } else {
                print("--->>>Subfamily was inserted, id =${subFam.id} <<<---");
              }
            }
            //return a list of subfamilies
            return responseObject;
          }
        } else {
          //return a empty list of subfamilies
          return responseObject;
        }
      }
    }
  }

  Future<ResponseObject> getArticlesOfSubfamily(String idSubFamily,) async {
    //ask first bd if it has articles, if not, call API
    List<Map<String, dynamic>> temp =
    await SQLHelper.getArticlesBySubFamilyId(idSubFamily);
    if (temp.isNotEmpty) {
      List<Article> listArticles = List.empty(growable: true);
      for (Map<String, dynamic> element in temp) {
        Article value = Article.fromJson(element);
        value.image = Image.memory(base64Decode(value.img ?? ""));
        listArticles.add(value);
      }
      return ResponseObject(
          responseObject: listArticles, status: true, errorObject: null);
    } else {
      ResponseObject responseObject = await _apiSource.getArticlesOfSubfamily(
          idSubFamily);
      bool res = responseObject.status ?? false;
      if (res) {
        List<Article> articles = responseObject.responseObject as List<Article>;
        if (articles.isNotEmpty) {
          for (Article article in articles) {
            String idArticle = "${article.id}";
            List<Map<String, dynamic>> resExist = await SQLHelper.getArticle(
                idArticle);
            if (resExist.isNotEmpty) {
              int resDelete = await SQLHelper.deleteArticle(idArticle);
              if (resDelete == 1) {
                int resInsert = await SQLHelper.createArticle(
                  idArticle: idArticle,
                  idSubfamily: idSubFamily,
                  beb: article.beb ?? false,
                  pvp: article.pvp,
                  regIvaVta: article.regIvaVta,
                  codBar: article.codBar,
                  name: article.name,
                  img: article.img,
                  idFamily: "",
                );
                if (resInsert != 0) {
                  print("--->>> was inserted Article id = ${article.id}");
                } else {
                  return ResponseObject(
                      status: false,
                      responseObject: null,
                      errorObject: ErrorObject(
                        errorObject: "",
                        errorCode: errorChargingData,
                        errorMessage: "Something went wrong inserting article id = ${article
                            .id} in the local data base",
                      )
                  );
                }
              }
            }
          }
          //if all the articles were insert in the local bd, return de original list
          // of articles because are the same.
          return responseObject;
        } else {
          //articles is empty
          return responseObject;
        }
      } else {
        //error
        return responseObject;
      }
    }
  }

  Future<ResponseObject> getArticlesAsFamily(Family family) async {
    //ask to db if it has data, if not, ask to API

    List<Map<String, dynamic>> listArticles =
    await SQLHelper.getArticlesByFamilyId(family.id ?? "");
    if (listArticles.isNotEmpty) {
      List<Article> temp = List.empty(growable: true);

      for (var element in listArticles) {
        Article article = Article.fromJson(element);
        temp.add(article);
      }

      return ResponseObject(
          responseObject: temp, status: true, errorObject: null);
    } else {
      return await _apiSource.getArticlesOfFamily(family);
    }
  }

  Future<bool> chargeSubfamiliesInDataBase() async {
    try {
      //get all families to create subfamilies after
      List<Map<String, dynamic>> listFamilies = await SQLHelper.getFamilies();
      List<Family> families = List.empty(growable: true);
      for (Map<String, dynamic> family in listFamilies) {
        if (family['id'] != null) {
          families.add(Family.fromJson(family));
        }
      }
      //check it has data
      if (families.isNotEmpty) {
        for (Family family in families) {
          String idFamily = family.id ?? "";
          if (idFamily != "") {
            //return a list of subfamily
            ResponseObject responseObject =
            await _apiSource.getSubfamily(family);
            if (!(responseObject.status ?? false)) {
              print(
                  "Error in sub_family_service.dart in method chargeSubfamiliesInDataBase."
                      " Family id=$idFamily don't have sub-families");
            }
            //if the family has sub-families
            else {
              List<SubFamily> temp =
              responseObject.responseObject as List<SubFamily>;
              if (temp.isNotEmpty) {
                //check if the db has subfamilies of the family and delete elements
                List<Map<String, dynamic>> listSubFamilies =
                await SQLHelper.getSubFamiliesByIdOfFamily(idFamily);
                bool allSubFamiliesDrop = true;
                String failureSubId = "";
                if (listSubFamilies.isNotEmpty) {
                  //try to delete all elements in the data base
                  for (Map<String, dynamic> elementSub in listSubFamilies) {
                    int res = 0;
                    if (elementSub['id'] != null) {
                      res = await SQLHelper.deleteSubFamily(elementSub['id']);
                    }
                    //affected rows must be one
                    if (res != 1 && elementSub['id'] != null) {
                      allSubFamiliesDrop = false;
                      failureSubId = elementSub["id"];
                      break;
                    }
                  }
                  if (!allSubFamiliesDrop) {
                    //if it false means that was drop more than one row in the data base
                    //that means something went wrong in the previous charge or was duplicated data
                    print("Something was wrong deleting the previous "
                        "family id: $failureSubId,"
                        " in sub_family_service.dart in method chargeSubfamiliesInDataBase");
                    return false;
                  } else {
                    //save sub-families
                    List<SubFamily> subFamily =
                    responseObject.responseObject as List<SubFamily>;
                    for (SubFamily subFam in subFamily) {
                      int i = await SQLHelper.createSubFamily(
                          idSubFamily: subFam.id ?? '',
                          idFamily: idFamily,
                          name: subFam.name ?? '',
                          img: subFam.img ?? '');
                      if (i == 0) {
                        print("Error in sub_family_service.dart"
                            " in method SQLHelper.createSubFamily for subfamily id=${subFam
                            .id ?? ''}. ");
                        return false;
                      } else {
                        print(
                            "--->>>Subfamily was inserted, id =${subFam
                                .id} <<<---");
                      }
                    }
                    return true;
                  }
                } else {
                  //save direct the sub-family
                  //save sub-families
                  List<SubFamily> subFamily = temp;
                  for (SubFamily subFam in subFamily) {
                    int i = await SQLHelper.createSubFamily(
                        idSubFamily: subFam.id ?? '',
                        idFamily: idFamily,
                        name: subFam.name ?? '',
                        img: subFam.img ?? '');
                    if (i == 0) {
                      print("Error in sub_family_service.dart"
                          " in method SQLHelper.createSubFamily for subfamily id=${subFam
                          .id ?? ''}. ");
                      return false;
                    } else {
                      print(
                          "--->>>Subfamily was inserted, id =${subFam
                              .id} <<<---");
                    }
                  }
                  return true;
                }
              }
            }
          }
        }
        //this true will never be returned unless all families don't have sub-families
        return true;
      } else {
        print("listFamilies hasn't has data");
        return false;
      }
    } catch (error) {
      print(
          "Error in family_service.dart. Error in Method chargeFamiliesInDataBase. Error: $error-------------->>>");
      return Future.value(false);
    }
  }
}
