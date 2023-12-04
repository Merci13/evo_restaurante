// ignore_for_file: use_build_context_synchronously, unnecessary_getters_setters

import 'dart:async';

import 'package:evo_restaurant/repositories/enums/view_state.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/service/article/article_service.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';
import 'package:evo_restaurant/utils/share/app_colors.dart';
import 'package:flutter/material.dart';
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
  bool _showLoading = false;
  bool _chargingData = false;
  bool _dataWasLoaded = false;

  StreamController<Widget> _chargingProcessWidgets =
      StreamController<Widget>.broadcast();

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

  bool get dataWasLoaded => _dataWasLoaded;

  bool get showLoading => _showLoading;

  bool get chargingData => _chargingData;

  StreamController<Widget> get chargingProcessWidgets =>
      _chargingProcessWidgets;

  set chargingProcessWidgets(StreamController<Widget> value) {
    _chargingProcessWidgets = value;
    notifyListeners();
  }

  set chargingData(bool value) {
    _chargingData = value;
    notifyListeners();
  }

  set showLoading(bool value) {
    _showLoading = value;
    notifyListeners();
  }

  set dataWasLoaded(bool value) {
    _dataWasLoaded = value;
    notifyListeners();
  }

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

  ///
  /// Check if the password given in the text form field it belongs to an administrator user
  /// return true or false
  ///
  Future<bool> checkPassword() async {
    if (passwordEditingController.text.isNotEmpty) {
      bool res = userService.checkPassword(passwordEditingController.text);
      return res;
    } else {
      return Future.value(false);
    }
  }

  ///
  /// Load all data that it is needed in the DB.
  /// -> Families
  /// -> Sub-Families
  /// -> Articles
  ///
  /// return false if something went wrong.
  ///
  Future<bool> resLoadingData() async {
    try {
      //loading families
      bool resFamilyCharge = await familyService.chargeFamiliesInDataBase();
      if (!resFamilyCharge) {
        print(
            "Error in home_view_model.dart in method resLoadingData. Error resFamilyCharge=false------------>>>>>");
        return false;
      } else {
        //loading sub-families
        bool resSubFamilyCharge =
            await subFamilyService.chargeSubfamiliesInDataBase();
        if (!resSubFamilyCharge) {
          print(
              "Error in home_view_model.dart in method resLoadingData. Error resSubFamilyCharge=false------------>>>>>");
          return false;
        } else {
          //loading  articles
          bool resArticlesCharge = await articleService.chargeArticles();
          if (!resArticlesCharge) {
            print(
                "Error in home_view_model.dart in method resLoadingData. Error resArticlesCharge=false------------>>>>>");
            return false;
          } else {
            return true;
          }
        }
      }
    } catch (error) {
      print(
          "Error in home_view_model.dart in method resLoadingData. Error: $error ------------->>>>>");
      return false;
    }
  }

  ///
  /// Execute a series of process to check the data in the data base,
  /// erased and update the data.
  ///
  /// First: check if the password is correct.
  /// Second: check if the database has data, if so, it will erased and load
  /// the new data, if it not, it will load the data.
  ///
  /// Also update the showDialog to show a changing widget.
  /// if something went wrong, the changing widget it will be update
  /// and shows an error message.
  ///
  ///
  void process(BuildContext contextOfProcess) async {
    try {
      if (state == ViewState.BUSY) {
        throw ErrorDescription("Finish the process to perform a new one");
      } else {
        setState(ViewState.BUSY);
        Size mediaQuery = MediaQuery.of(context).size;

        ///check if password is correct

        // _chargingProcessWidgets

        ///Loading widget
        chargingProcessWidgets.add(Container(
          width: mediaQuery.width * 0.3,
          height: mediaQuery.width * 0.2,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Title container
              Expanded(
                flex: 25,
                child: Container(
                  width: double.infinity,
                  height: mediaQuery.height * 0.05,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(7),
                      topLeft: Radius.circular(7),
                    ),
                    color: colorPrimary,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 75,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)?.evoRestaurantText ??
                                  "",
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          )),
                      Expanded(
                          flex: 25,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)?.chargingDataText ??
                                  "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              //content container
              const Expanded(
                flex: 75,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
        ));
        bool resPassword = await checkPassword();
        passwordEditingController.text = "";
        if (!resPassword) {
          chargingProcessWidgets.add(Container(
            width: mediaQuery.width * 0.3,
            height: mediaQuery.width * 0.2,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Title container
                Expanded(
                  flex: 25,
                  child: Container(
                    width: double.infinity,
                    height: mediaQuery.height * 0.05,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        topLeft: Radius.circular(7),
                      ),
                      color: colorPrimary,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 75,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                        ?.evoRestaurantText ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            )),
                        Expanded(
                            flex: 25,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)?.errorText ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                //content container
                Expanded(
                  flex: 75,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.yellow[700],
                      ),
                      Text(
                        AppLocalizations.of(context)
                                ?.passwordIsNotCorrectText ??
                            "",
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      Container(
                        width: mediaQuery.width * 0.1,
                        height: mediaQuery.width * 0.05,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          color: colorPrimary,
                        ),
                        child: TextButton(
                          onPressed: () {
                            chargingProcessWidgets.stream.drain();
                            Navigator.pop(contextOfProcess);
                          },
                          child: Text(
                            AppLocalizations.of(context)?.acceptText ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
        } else {
          ///Loading data from API
          chargingProcessWidgets.add(Container(
            width: mediaQuery.width * 0.3,
            height: mediaQuery.width * 0.2,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Title container
                Expanded(
                  flex: 25,
                  child: Container(
                    width: double.infinity,
                    height: mediaQuery.height * 0.05,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        topLeft: Radius.circular(7),
                      ),
                      color: colorPrimary,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 75,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                        ?.evoRestaurantText ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            )),
                        Expanded(
                            flex: 25,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                        ?.chargingDataText ??
                                    "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                //content container
                Expanded(
                  flex: 75,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.chargingDataText ?? "",
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
          bool resChargingData = await resLoadingData();
          if (!resChargingData) {
            chargingProcessWidgets.add(Container(
              width: mediaQuery.width * 0.3,
              height: mediaQuery.width * 0.2,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Title container
                  Expanded(
                    flex: 25,
                    child: Container(
                      width: double.infinity,
                      height: mediaQuery.height * 0.05,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7),
                          topLeft: Radius.circular(7),
                        ),
                        color: colorPrimary,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 75,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.evoRestaurantText ??
                                      "",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              )),
                          Expanded(
                              flex: 25,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)?.errorText ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  //content container
                  Expanded(
                    flex: 75,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 30,
                          color: Colors.yellow[700],
                        ),
                        Text(
                          AppLocalizations.of(context)
                                  ?.chargingDataFailedText ??
                              "",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        Container(
                          width: mediaQuery.width * 0.1,
                          height: mediaQuery.width * 0.05,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: colorPrimary,
                          ),
                          child: TextButton(
                            onPressed: () {
                              chargingProcessWidgets.stream.drain();
                              Navigator.pop(contextOfProcess);
                            },
                            child: Text(
                              AppLocalizations.of(context)?.acceptText ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
          }
          else {
            AppLocalizations.of(context)?.loadingDataSuccessfullyText ?? "";
            chargingProcessWidgets.add(Container(
              width: mediaQuery.width * 0.3,
              height: mediaQuery.width * 0.2,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Title container
                  Expanded(
                    flex: 25,
                    child: Container(
                      width: double.infinity,
                      height: mediaQuery.height * 0.05,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7),
                          topLeft: Radius.circular(7),
                        ),
                        color: colorPrimary,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 75,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.evoRestaurantText ??
                                      "",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              )),
                          Expanded(
                              flex: 25,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)?.okText ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  //content container
                  Expanded(
                    flex: 75,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 30,
                          color: Colors.yellow[700],
                        ),
                        Text(
                          AppLocalizations.of(context)
                                  ?.loadingDataSuccessfullyText ??
                              "",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        Container(
                          width: mediaQuery.width * 0.1,
                          height: mediaQuery.width * 0.05,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: colorPrimary,
                          ),
                          child: TextButton(
                            onPressed: () {
                              chargingProcessWidgets.stream.drain();
                              Navigator.pop(contextOfProcess);
                            },
                            child: Text(
                              AppLocalizations.of(context)?.acceptText ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
          }
        }
        setState(ViewState.IDLE);

      }
    } catch (error) {
      setState(ViewState.IDLE);
      print(
          "Error in home_view_model.dart, in method process. Error: $error ------->>");
      Size mediaQuery = MediaQuery.of(context).size;
      chargingProcessWidgets.add(Container(
        width: mediaQuery.width * 0.3,
        height: mediaQuery.width * 0.2,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Title container
            Expanded(
              flex: 25,
              child: Container(
                width: double.infinity,
                height: mediaQuery.height * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    topLeft: Radius.circular(7),
                  ),
                  color: colorPrimary,
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 75,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)?.evoRestaurantText ??
                                "",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        )),
                    Expanded(
                        flex: 25,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)?.errorText ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            //content container
            Expanded(
              flex: 75,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.warning,
                    size: 30,
                    color: Colors.yellow[700],
                  ),
                  Text(
                    AppLocalizations.of(context)?.somethingWentWrongText ?? "",
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  Container(
                    width: mediaQuery.width * 0.1,
                    height: mediaQuery.width * 0.05,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: colorPrimary,
                    ),
                    child: TextButton(
                      onPressed: () {
                        chargingProcessWidgets.stream.drain();
                        Navigator.pop(contextOfProcess);
                      },
                      child: Text(
                        AppLocalizations.of(context)?.acceptText ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ));

    }
  }

  @override
  void dispose() {
    chargingProcessWidgets.stream.drain();
    chargingProcessWidgets.close();
    super.dispose();
  }
}
