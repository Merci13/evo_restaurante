import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/hall.dart';
import '../models/user.dart';

class HomeViewModel extends BaseModel {
  late User _user;
  late UserService _userService;
  late HallService _hallService;
  List<Hall> _listOfHalls = List.empty(growable: true);
  late BuildContext _context;
  String _errorMessage = "";

  UserService get userService => _userService;

  User get user => _user;

  List<Hall> get listOfHalls => _listOfHalls;


  HallService get hallService => _hallService;


  BuildContext get context => _context;


  String get errorMessage => _errorMessage;

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

  init() async {
    try {
      listOfHalls.clear();
      ResponseObject responseHalls = await _hallService.getAllHalls();
      bool res = responseHalls.status ?? false;
      if(!res){
        errorMessage = AppLocalizations.of(context).somethingWentWrongText;
        listOfHalls.clear();
        notifyListeners();
      }else{
        listOfHalls.addAll(responseHalls.responseObject as List<Hall>);
        notifyListeners();
      }

    } catch (error) {
      print("Error in HomeViewModel. Error: $error -------->>>");
    }
  }
}
