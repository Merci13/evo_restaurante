

import 'package:evo_restaurant/repositories/enums/view_state.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/service/article/article_service.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/hall.dart';
import '../models/user.dart';

class HomeViewModel extends BaseModel {
  late User _user;
  late UserService _userService;
  late HallService _hallService;
  late FamilyService _familyService;
  late SubFamilyService _subFamilyService;
  late ArticleService _articleService;
  List<Hall> _listOfHalls = List.empty(growable: true);
  late BuildContext _context;
  String _errorMessage = "";
  bool _flag = true;
  bool _showPassword = false;
  FocusNode _passwordFocusNode = FocusNode();
  TextEditingController _passwordEditingController = TextEditingController();


  UserService get userService => _userService;

  User get user => _user;

  List<Hall> get listOfHalls => _listOfHalls;

  HallService get hallService => _hallService;

  BuildContext get context => _context;

  String get errorMessage => _errorMessage;

  bool get flag => _flag;


  FocusNode get passwordFocusNode => _passwordFocusNode;

  TextEditingController get passwordEditingController =>
      _passwordEditingController;


  bool get showPassword => _showPassword;


  FamilyService get familyService => _familyService;


  ArticleService get articleService => _articleService;


  SubFamilyService get subFamilyService => _subFamilyService;

  set subFamilyService(SubFamilyService value) {
    _subFamilyService = value;
  }

  set articleService(ArticleService value) {
    _articleService = value;
  }

  set familyService(FamilyService value) {
    _familyService = value;
  }

  set showPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  set passwordEditingController(TextEditingController value) {
    _passwordEditingController = value;
    notifyListeners();
  }

  set passwordFocusNode(FocusNode value) {
    _passwordFocusNode = value;
    notifyListeners();
  }

  set flag(bool value) {
    _flag = value;
    notifyListeners();
  }

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  set context(BuildContext value) {
    _context = value;
  }

  set hallService(HallService value) {
    _hallService = value;
  }

  set listOfHalls(List<Hall> value) {
    _listOfHalls = value;
    notifyListeners();
  }

  set user(User value) {
    _user = value;
  }

  set userService(UserService value) {
    _userService = value;
  }

  init(AppLocalizations? appLocalizations) async {
    try {
      if (flag) {
        listOfHalls.clear();
        if (state == ViewState.IDLE) {
          setState(ViewState.BUSY);
          ResponseObject responseHalls = await _hallService.getAllHalls();
          bool res = responseHalls.status ?? false;
          if (!res) {
            errorMessage = appLocalizations?.somethingWentWrongText ?? "";
            listOfHalls.clear();
          } else {
            listOfHalls.addAll(responseHalls.responseObject as List<Hall>);
          }
          setState(ViewState.IDLE);
          notifyListeners();
        }

        flag = false;
      }
    } catch (error) {
      print("Error in HomeViewModel. Error: $error -------->>>");
    }
  }

  Future<bool> checkPassword() async {

    if(passwordEditingController.text.isNotEmpty){
      bool res = userService.checkPassword(passwordEditingController.text);
      return res;
    }else{
      return Future.value(false);
    }



  }

  Future<bool> resLoadingData() async {

    try{

      bool resFamilyCharge = await familyService.chargeFamiliesInDataBase();


      return resFamilyCharge;

    }catch(error){
      print("Error in home_view_model.dart in method resLoadingData. Error: $error ------------->>>>>");
      return false;
    }

  }
}
