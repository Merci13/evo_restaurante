import 'dart:async';

import 'package:evo_restaurant/repositories/enums/view_state.dart';
import 'package:evo_restaurant/repositories/models/article.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/models/sub_family.dart';
import 'package:evo_restaurant/repositories/models/user.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class FamilyViewModel extends BaseModel {
  late User _user;
  late UserService _userService;
  late Family _family;
  late FamilyService _familyService;
  late SubFamilyService _subFamilyService;
  List<Family> _listOfFamilies = List.empty(growable: true);

  List<Article> _listOfArticlesOfFamily = List.empty(growable: true);

  List<SubFamily> _listOfSubFamily = List.empty(growable: true);
  StreamController<List<Article>> _controllerArticles = BehaviorSubject();


  User get user => _user;

  UserService get userService => _userService;

  Family get family => _family;

  FamilyService get familyService => _familyService;


  List<Article> get listOfArticlesOfFamily => _listOfArticlesOfFamily;


  SubFamilyService get subFamilyService => _subFamilyService;


  List<SubFamily> get listOfSubFamily => _listOfSubFamily;


  List<Family> get listOfFamilies => _listOfFamilies;


  StreamController<List<Article>> get controllerArticles => _controllerArticles;

  set controllerArticles(StreamController<List<Article>> value) {
    _controllerArticles = value;
    notifyListeners();
  }

  set listOfFamilies(List<Family> value) {
    _listOfFamilies = value;
    notifyListeners();
  }

  set listOfSubFamily(List<SubFamily> value) {
    _listOfSubFamily = value;
    notifyListeners();
  }

  set subFamilyService(SubFamilyService value) {
    _subFamilyService = value;
  }

  set listOfArticlesOfFamily(List<Article> value) {
    _listOfArticlesOfFamily = value;
    notifyListeners();
  }

  set user(User value) {
    _user = value;
  }

  set userService(UserService value) {
    _userService = value;
  }

  set family(Family value) {
    _family = value;
  }

  set familyService(FamilyService value) {
    _familyService = value;
  }

  init()async{

    if(state == ViewState.BUSY){
      throw ErrorDescription("Finish the process to perform a new one");
    }else{

      ResponseObject responseObjectSubFam = await subFamilyService.getSubfamily(family);
      bool res = responseObjectSubFam.status ?? false;
      if(res){
        listOfSubFamily = responseObjectSubFam.responseObject as List<SubFamily>;
        bool resArticlesSubfamily =  await chargeArticlesOfSubFamily(listOfFamilies.first.id ?? "", family.id ?? "");
         ResponseObject responseObjectArticle = await subFamilyService.getArticlesAsFamily(family);
      }


      setState(ViewState.IDLE);
      notifyListeners();
    }

  }

  Future<bool> chargeArticlesOfSubFamily(String id, String idFamily) async {
    try {
      if(controllerArticles.isClosed){
        controllerArticles = BehaviorSubject();
      }else{
        controllerArticles.sink;
      }

      ResponseObject responseObject =
      await subFamilyService.getArticlesOfSubfamily(id);
      bool res = responseObject.status ?? false;
      if (res) {
        controllerArticles.sink;
        controllerArticles.add(responseObject.responseObject as List<Article>);
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(
          "Error in chargeArticlesOfSubFamily method in table_view_model.dart. Error $error ----------->>>");
      return Future.value(false);
    }

  }

  @override
  void dispose() {
    controllerArticles.close();
    super.dispose();
  }
}
