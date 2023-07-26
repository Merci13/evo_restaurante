import 'package:evo_restaurant/repositories/enums/view_state.dart';
import 'package:evo_restaurant/repositories/models/hall.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/models/user.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/table.dart' as own_table;

class HallViewModel extends BaseModel {
  late User _user;
  late UserService _userService;
  late HallService _hallService;
  List<own_table.Table> _listOfTables = List.empty(growable: true);
  bool _flag = true;

  late Hall _hall;

  User get user => _user;

  UserService get userService => _userService;

  HallService get hallService => _hallService;

  Hall get hall => _hall;


  List<own_table.Table> get listOfTables => _listOfTables;


  bool get flag => _flag;

  set flag(bool value) {
    _flag = value;
    notifyListeners();
  }

  set listOfTables(List<own_table.Table> value) {
    _listOfTables = value;
    notifyListeners();
  }

  set hall(Hall value) {
    _hall = value;
  }

  set hallService(HallService value) {
    _hallService = value;
  }

  set userService(UserService value) {
    _userService = value;
  }

  set user(User value) {
    _user = value;
  }

  init() async {
    try{
      if(flag){
          listOfTables.clear();
        if(state == ViewState.IDLE){
          setState(ViewState.BUSY);
          ResponseObject responseTable = await hallService.getAllTables(hall);

          if(responseTable.status ?? false){
            listOfTables.addAll(responseTable.responseObject as List<own_table.Table>);
          }else{
            listOfTables.clear();
          }

          setState(ViewState.IDLE);
        }else{
          throw ErrorDescription("Finish the process to perform a new one");
        }


        flag = false;
        notifyListeners();
      }

    }catch(error){
      print("Error in hall_view_model.dart. Error: $error ----------->>>>");
    }

  }

  Future<ResponseObject> getTable(own_table.Table table) async {
    try{

      if(state == ViewState.BUSY){
        throw ErrorDescription("Finish the process to perform a new one");
      }else{
        setState(ViewState.BUSY);

        ResponseObject responseObject = await hallService.getTable(table);
        if(responseObject.status ?? false){
          setState(ViewState.IDLE);
          return responseObject;



        }else{
          setState(ViewState.IDLE);
          return ResponseObject(
            status: false,
            errorObject: null
          );
        }

      }

    }catch(error){

      print("Error in getTable method in hall_view_model.dart. Error: $error ------->>>>>");
      setState(ViewState.IDLE);
      return ResponseObject(
        status: false,
        responseObject: null
      );

    }


  }
}
