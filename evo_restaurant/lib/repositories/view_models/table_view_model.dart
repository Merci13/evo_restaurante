// ignore_for_file: unnecessary_getters_setters

import 'dart:async';

import 'package:evo_restaurant/repositories/enums/view_state.dart';
import 'package:evo_restaurant/repositories/models/article.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/models/table_detail.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/command_table/command_table_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../models/family.dart';
import '../models/sub_family.dart';
import '../models/table.dart' as own_table;
import '../models/user.dart';
import '../service/table/table_service.dart';
import 'base_model.dart';

class TableViewModel extends BaseModel {
  late User _user;
  late UserService _userService;
  late CommandTableService _commandTableService;
  late TableDetail _tableDetail;
  late TableService _tableService;
  late own_table.Table _table;
  late FamilyService _familyService;
  late BuildContext _context;
  late SubFamilyService _subFamilyService;
  List<Family> _listOfFamilies = List.empty(growable: true);
  List<SubFamily> _listOfSubFamilies = List.empty(growable: true);
  List<Article> _listOfArticlesBySubFamily = List.empty(growable: true);
  List<Article> _listOfArticlesByFamily = List.empty(growable: true);
  int _isFamilySelected = -1;

  String _subfamilySelected = "";

  String _errorMessage = "";
  bool _flagControl = true;

  own_table.Table get table => _table;

  UserService get userService => _userService;

  User get user => _user;

  CommandTableService get commandTableService => _commandTableService;

  TableService get tableService => _tableService;

  TableDetail get tableDetail => _tableDetail;

  FamilyService get familyService => _familyService;

  List<Family> get listOfFamilies => _listOfFamilies;

  BuildContext get context => _context;

  String get errorMessage => _errorMessage;

  List<SubFamily> get listOfSubFamilies => _listOfSubFamilies;

  SubFamilyService get subFamilyService => _subFamilyService;

  List<Article> get listOfArticlesBySubFamily => _listOfArticlesBySubFamily;

  String get subfamilySelected => _subfamilySelected;

  int get isFamilySelected => _isFamilySelected;

  List<Article> get listOfArticlesByFamily => _listOfArticlesByFamily;

  set listOfArticlesByFamily(List<Article> value) {
    _listOfArticlesByFamily = value;
    notifyListeners();
  }

  set isFamilySelected(int value) {
    _isFamilySelected = value;
    notifyListeners();
  }

  set subfamilySelected(String value) {
    _subfamilySelected = value;
    notifyListeners();
  }

  set listOfArticlesBySubFamily(List<Article> value) {
    _listOfArticlesBySubFamily = value;
    notifyListeners();
  }

  set subFamilyService(SubFamilyService value) {
    _subFamilyService = value;
  }

  set listOfSubFamilies(List<SubFamily> value) {
    _listOfSubFamilies = value;
    notifyListeners();
  }

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  set context(BuildContext value) {
    _context = value;
  }

  set listOfFamilies(List<Family> value) {
    _listOfFamilies = value;
    notifyListeners();
  }

  set familyService(FamilyService value) {
    _familyService = value;
  }

  set tableDetail(TableDetail value) {
    _tableDetail = value;
  }

  set tableService(TableService value) {
    _tableService = value;
  }

  set commandTableService(CommandTableService value) {
    _commandTableService = value;
  }

  set user(User value) {
    _user = value;
  }

  set userService(UserService value) {
    _userService = value;
  }

  set table(own_table.Table value) {
    _table = value;
  }

  init() async {
    if (state == ViewState.BUSY) {
      throw ErrorDescription("Finish the process to perform a new one");
    } else {
      setState(ViewState.BUSY);
      listOfFamilies.clear();
      ResponseObject resFamilies = await familyService.getFamilies();
      bool res = resFamilies.status ?? false;
      if (!res) {
        errorMessage = AppLocalizations.of(context).somethingWentWrongText;
      } else {
        listOfFamilies.addAll(resFamilies.responseObject as List<Family>);
      }

      setState(ViewState.IDLE);
    }
    notifyListeners();
  }

  String getTotalOfCommand() {
    int val = 0;
    tableDetail.commandTable?.forEach((element) {
      val = val + ((element.can ?? 0) * (element.pre ?? 0));
    });
    return "$val";
  }

  Future<bool> chargeSubfamily(Family family) async {
    try {
      ResponseObject responseObject =
          await subFamilyService.getSubfamily(family);
      bool res = responseObject.status ?? false;
      if (res) {
        listOfSubFamilies
            .addAll(responseObject.responseObject as List<SubFamily>);
        return true;
      } else {
        throw ErrorDescription("Error trying load subfamilies");
      }
    } catch (error) {
      print(
          "Error in chargeSubFamily method in table_view_model.dart. Error $error ----------->>>");
      return Future.value(false);
    }
  }

  Future<bool> addArticleToCommand(Article data) async {
    try {
      if (state == ViewState.BUSY) {
        throw ErrorDescription("Finish the process to perform a new one");
      }
      setState(ViewState.BUSY);

      return Future.value(true);

      setState(ViewState.IDLE);
    } catch (error) {
      print(
          "Error in addArticleToCommand method in table_view_model.dart. Error $error ----------->>>");
      return Future.value(false);
    }
  }

  void addToCounter(Article article) {}

  String getCounterOfArticle(Article article) {
    return "0";
  }

  void restToCounter(Article article) {}

  Future<bool> loadArticlesOfFamilyAndSubfamilies(int value) async {
    int val = value;
    if (val != -1) {
      //load Articles that are children of family
      ResponseObject responseObject =
          await familyService.getArticlesOfFamily(listOfFamilies[val]);
      bool res = responseObject.status ?? false;
      if (res) {
        listOfArticlesByFamily = responseObject.responseObject as List<Article>;
        return true;
      }
      listOfArticlesByFamily.clear();
      return false;
    }
    return false;
  }
}
