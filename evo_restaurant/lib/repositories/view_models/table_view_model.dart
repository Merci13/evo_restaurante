// ignore_for_file: unnecessary_getters_setters, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:evo_restaurant/repositories/enums/view_state.dart';
import 'package:evo_restaurant/repositories/models/article.dart';
import 'package:evo_restaurant/repositories/models/command_table.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/models/table_detail.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/command_table/command_table_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/family.dart';
import '../models/sub_family.dart';
import '../models/table.dart' as own_table;
import '../models/user.dart';
import '../service/table/table_service.dart';
import 'base_model.dart';

class TableViewModel extends BaseModel {
  bool _flag = true;
  late User _user;
  late UserService _userService;
  late CommandTableService _commandTableService;
  late TableDetail _tableDetail;
  late TableService _tableService;
  late own_table.Table _table;
  late FamilyService _familyService;
  late BuildContext _context;
  late SubFamilyService _subFamilyService;
  late List<CommandTable> _listOfCommand = List.empty(growable: true);
  late List<CommandTable> _listOfCommandImmutable = List.empty(growable: true);

  List<Family> _listOfFamilies = List.empty(growable: true);
  List<SubFamily> _listOfSubFamilies = List.empty(growable: true);
  List<Article> _listOfArticlesBySubFamily = List.empty(growable: true);
  List<Article> _listOfArticlesByFamily = List.empty(growable: true);
  Map<String, bool> _listCommandLineWasChecked = {};

  bool _searching = false;
  int _isFamilySelected = -1;
  int _subfamilySelected = -1;

  String _errorMessage = "";
  String _errorMessageInit = "";

  FocusNode _administratorPasswordFocusNode = FocusNode();
  TextEditingController _administratorPasswordTextController =
      TextEditingController();

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

  int get subfamilySelected => _subfamilySelected;

  int get isFamilySelected => _isFamilySelected;

  List<Article> get listOfArticlesByFamily => _listOfArticlesByFamily;

  List<CommandTable> get listOfCommand => _listOfCommand;

  TextEditingController get administratorPasswordTextController =>
      _administratorPasswordTextController;

  FocusNode get administratorPasswordFocusNode =>
      _administratorPasswordFocusNode;

  String get errorMessageInit => _errorMessageInit;

  Map<String, bool> get listCommandLineWasChecked => _listCommandLineWasChecked;


  bool get searching => _searching;

  set searching(bool value) {
    _searching = value;
    notifyListeners();
  }

  set listCommandLineWasChecked(Map<String, bool> value) {
    _listCommandLineWasChecked = value;
    notifyListeners();
  }

  set errorMessageInit(String value) {
    _errorMessageInit = value;
    notifyListeners();
  }

  set administratorPasswordFocusNode(FocusNode value) {
    _administratorPasswordFocusNode = value;
    notifyListeners();
  }

  set administratorPasswordTextController(TextEditingController value) {
    _administratorPasswordTextController = value;
    notifyListeners();
  }

  set listOfCommand(List<CommandTable> value) {
    _listOfCommand = value;
  }

  set listOfArticlesByFamily(List<Article> value) {
    _listOfArticlesByFamily = value;
    notifyListeners();
  }

  set isFamilySelected(int value) {
    _isFamilySelected = value;
    notifyListeners();
  }

  set subfamilySelected(int value) {
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
    if (_flag) {
      if (state == ViewState.BUSY) {
        throw ErrorDescription("Finish the process to perform a new one");
      } else {
        try {
          setState(ViewState.BUSY);
          listOfFamilies.clear();
          ResponseObject resFamilies = await familyService.getFamilies();
          bool res = resFamilies.status ?? false;
          if (!res) {
            errorMessage =
                AppLocalizations.of(context)?.somethingWentWrongText ?? "";
          } else {
            listOfFamilies.addAll(resFamilies.responseObject as List<Family>);
          }
          //--------------------------------------------------------------------//
          ///
          ///this section was needed because when listOfCommand and _listOfCommandImmutable
          ///were copying tableDetail.commandTable, they copy the memory point that was located,
          ///so, the solution to this problem was converting the data in a string json to create a
          ///temporal memory of the object, recreate the data in a Map<String, dynamic> type,
          ///and take this map to create an object of CommandTable to finally add this new object
          ///to the listOfCommand and _listOfCommandImmutable
          ///

          if (tableDetail.commandTable!.isNotEmpty) {
            String jsonTemp = CommandTable.toJson(tableDetail.commandTable!);

            Map<String, dynamic> jsonCon = jsonDecode(jsonTemp);
            jsonCon.forEach((key, value) {
              print("$key : $value");
              List<dynamic> conv = jsonCon["items"];
              for (var element in conv) {
                print("$element");
                listOfCommand.add(CommandTable.fromJson(element));
                for (CommandTable value in listOfCommand) {
                  listCommandLineWasChecked.putIfAbsent(
                      "${value.id}", () => false);
                }
                _listOfCommandImmutable.add(CommandTable.fromJson(element));
              }
            });
          }

          //--------------------------------------------------------------------//

          setState(ViewState.IDLE);
          notifyListeners();

          _flag = false;
        } catch (error) {
          _errorMessageInit =
              AppLocalizations.of(context)?.initErrorMessageTableText ?? "";
          print(
              "Error in init method in table_view_model.dart. Error: $error ---------->>>");
        }
      }
    }
  }

  String getTotalOfCommand() {
    int val = 0;
    for (var element in listOfCommand) {
      val = val + ((element.can ?? 0) * (element.pre ?? 0));
    }
    return "$val";
  }

  Future<bool> chargeSubfamily(Family family) async {
    try {
      listOfSubFamilies.clear();
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
      //verify if the article already exist in the command
      bool itsThere = false;
      CommandTable commandLine = CommandTable();
      for (var element in listOfCommand) {
        if (element.idArt == data.id) {
          itsThere = true;
          commandLine = element;
        }
      }

      if (itsThere) {
        //add to the current amount  of the article
        int index = listOfCommand.indexOf(commandLine);
        listOfCommand[index].can = listOfCommand[index].can! + 1;
      } else {
        //check if there are more lines in the command
        int line = 0;
        if (listOfCommand.length > 0) {
          line = listOfCommand.length + 1;
        }
        //add to the command
        int iva = 0;
        switch (data.regIvaVta ?? "0") {
          case "G":
            iva = 13;
            break;
          case "R":
            iva = 2;
            break;
          case "S":
            iva = 1;
            break;
          case "E":
            iva = 4;
            break;
          case "X":
            iva = 0;
            break;
          default:
            iva = 0;
            break;
        }
        listOfCommand.add(CommandTable(
          name: data.name,
          //id: ,
          can: 1,
          cBar: int.tryParse(data.codBar ?? "0"),
          depT: user.id,
          fec: DateTime.now().toIso8601String(),
          idArt: data.id,
          idLin: line,
          imp: data.pvp,
          //total of the line
          mesT: table.num,
          porDto: 0,
          porIva: iva,
          pre: data.pvp,
          preNet: 0,
        ));
      }

      setState(ViewState.IDLE);
      return Future.value(true);
    } catch (error) {
      print(
          "Error in addArticleToCommand method in table_view_model.dart. Error $error ----------->>>");
      return Future.value(false);
    }
  }

  Future<bool> loadArticlesOfFamilyAndSubfamilies(int value) async {
    try {
      int val = value;
      if (val != -1) {
        //load Articles that are children of family
        ResponseObject responseObject =
            await familyService.getArticlesOfFamily(listOfFamilies[val]);
        bool res = responseObject.status ?? false;
        if (res) {
          listOfArticlesByFamily.clear();
          listOfArticlesByFamily =
              responseObject.responseObject as List<Article>;
          bool resSub = await chargeSubfamily(listOfFamilies[value]);

          return resSub;
        }
        listOfArticlesByFamily.clear();
        return false;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> loadArticlesOfSubfamily(String idSuFamily) async {
    try {
      listOfArticlesBySubFamily.clear();
      ResponseObject responseObject =
          await subFamilyService.getArticlesOfSubfamily(idSuFamily);
      bool res = responseObject.status ?? false;
      if (res) {
        listOfArticlesBySubFamily =
            responseObject.responseObject as List<Article>;
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool restArticle(int index) {
    //check if it exist in the original command
    bool exist = false;
    int indexInImmutable = 0;
    for (int i = 0; _listOfCommandImmutable.length > i; i++) {
      if (_listOfCommandImmutable[i].id == listOfCommand[index].id) {
        exist = true;
        indexInImmutable = i;
        break;
      }
    }
    if (exist) {
      if ((listOfCommand[index].can! - 1) <
          (_listOfCommandImmutable[indexInImmutable].can ?? 0)) {
        return false;
      } else {
        listOfCommand[index].can = listOfCommand[index].can! - 1;
      }
    } else {
      //if not existing in the original command rest 1 or eliminate the command line
      if ((listOfCommand[index].can! - 1) < 1) {
        listOfCommand.remove(listOfCommand[index]);
      } else {
        listOfCommand[index].can = listOfCommand[index].can! - 1;
      }
    }

    notifyListeners();
    return true;
  }

  void add(int index) {
    listOfCommand[index].can = ((listOfCommand[index].can ?? 0) + 1);
    notifyListeners();
  }

  Future<bool> sendCommand() async {
    try {
      if (state == ViewState.BUSY) {
        throw ErrorDescription("Finish the process to perform a new one");
      }
      setState(ViewState.BUSY);

      ResponseObject responseObject =
          await tableService.sendCommand(listOfCommand, "${_table.id}");

      setState(ViewState.IDLE);

      return responseObject.status ?? false;
    } catch (error) {
      print(
          "Error sending command to review, Error in table_view_model.dart file in sendCommand method."
          "Error: $error.");
      return false;
    }
  }

  bool checkAdminPassword() {
    return userService.checkPassword(_administratorPasswordTextController.text);
  }

  void restArticleByAdmin(int index) {
    if ((listOfCommand[index].can! - 1) < 1) {
      listOfCommand.remove(listOfCommand[index]);
    } else {
      listOfCommand[index].can = listOfCommand[index].can! - 1;
    }
    notifyListeners();
  }

  bool getIfWasChecked(int index) {
    bool val = false;
    listCommandLineWasChecked.forEach((key, value) {
      if (key == "${listOfCommand[index].id}") {
        val = value;
      }
    });

    return val;
  }
}
