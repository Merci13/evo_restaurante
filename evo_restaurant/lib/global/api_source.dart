import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:evo_restaurant/global/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../repositories/models/error_object.dart';
import '../repositories/models/family.dart';
import '../repositories/models/response_object.dart';
import '../repositories/models/user.dart';
import 'error_codes.dart';

class HasToken {
  final bool? hasToken;

  // String userId = UniqueKey().toString();
  String? userId;

  HasToken({this.hasToken});
}

class HasUserId {
  String? userId;

  HasUserId({this.userId});
}

class ApiSource {
  String? _token;
  String basePath = Config.basePath;
  String apiKey = Config.apiKey;
  String table = Config.table;

  final StreamController<HasToken> _hasToken = StreamController.broadcast();
  final StreamController<HasUserId> _hasUserID = StreamController.broadcast();
  late BuildContext? _context;
  late SharedPreferences? _sharedPreferences;

  // String uId = UniqueKey().toString();
  String _uId = "";

  String? get token => _token;

  String? get userId => _uId;

  Stream<HasToken> get hasToken => _hasToken.stream;

  Stream<HasUserId> get hasUserId => _hasUserID.stream;

  set context(BuildContext value) {
    _context = value;
  }

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _token = _sharedPreferences?.getString("token") ?? '';
    _hasToken.add(HasToken(hasToken: (_token ?? '').isNotEmpty));

    print(
        "ID: Remover despues, linea 68 en global/api_source.dart------------>>>>>>>>>>>>>> ${_hasUserID.stream.first} \n Token: $_token");
    if (_token?.isNotEmpty ?? false) {
      ResponseObject result = await Future.value(ResponseObject(status: false)); //await getUserInformationByToken();

      if (result.status ?? false) {
        User user = result.responseObject as User;
        _hasUserID.add(HasUserId(userId: "${user.id ?? ""}"));
      } else {
        _hasUserID.stream.drain();
        _hasUserID.add(HasUserId(userId: ""));
        _sharedPreferences?.remove("token");
        _hasToken.add(HasToken(hasToken: false));
        if (kDebugMode) {
          print(result.errorObject?.message);
        }
      }
    } else {
      _hasUserID.add(HasUserId(userId: ""));
      _sharedPreferences?.remove("token");
      _hasToken.add(HasToken(hasToken: false));
    }
  }

  Future<ResponseObject> updateToken(String value, String username) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      bool? containKey = _sharedPreferences?.containsKey("token");
      if (containKey ?? false) {
        _sharedPreferences?.remove("token");
      }
      if (value.isNotEmpty) {
        await _sharedPreferences?.setString("token", value);
        //save the token and the user name as a pair because we need both to perform the search by token
        await _sharedPreferences?.setString(value, username);
      } else {
        return ResponseObject(
            status: false,
            errorObject: ErrorObject(
                status: false,
                errorMessage: "The token is empty",
                errorCode: errorTokenEmpty));
      }
      _token = value;
      _hasToken.add(HasToken(hasToken: value.isNotEmpty));
      return ResponseObject(
        status: true,
      );
    } catch (error) {
      log("Error in method updateToken in api_source. Error: $error --------------------->>>>>>>>>>");
      return ResponseObject(
        status: false,
        errorObject: ErrorObject(
            status: false,
            errorMessage: error.toString(),
            errorCode: errorUpdateToken,
            errorObject: error),
      );
    }
  }

  Future<String> getRememberUserName() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    bool? containKey = _sharedPreferences?.containsKey("user-name");
    String? userNameRemember;
    if (containKey ?? false) {
      userNameRemember = _sharedPreferences!.getString("user-name");
    }
    return userNameRemember ?? "";
  }

  Future<ResponseObject> login(bool valid, bool rememberUserName, User userValidation) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      if (!valid) {
        return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            message: "The password is not correct",
            errorObject: null,
            errorCode: errorPasswordIsNotCorrect,
            errorMessage: "The password is not correct",
          ),
        );
      } else {
        if (rememberUserName) {
          bool containKey = _sharedPreferences!.containsKey("user-name");
          if (containKey) {
            if (await _sharedPreferences!.remove("user-name")) {
              await _sharedPreferences!.setString("user-name", userValidation.name ?? "");
            }
          } else {
            await _sharedPreferences!.setString("user-name", userValidation.name ?? "");
          }
        } else {
          await _sharedPreferences!.remove("user-name");
        }

        String token = "isLogged";

        await updateToken(token, userValidation.name ?? "");

        return ResponseObject(status: true, responseObject: token);
      }
    } catch (error) {
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
              status: false,
              message: error.toString(),
              errorObject: error,
              errorCode: errorTokenEmpty,
              errorMessage: error.toString()));
    }
  }

  Future<ResponseObject> getFamilies() async {
    try {
      String path = "$basePath/$table/fam_m?[off]=0&api_key=$apiKey";
      Uri url = Uri.parse(path);

      http.Response response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode != 200) {
        return ResponseObject(
            status: false,
            errorObject: ErrorObject(
              status: false,
              errorObject: response.body,
              errorMessage: response.body,
            ));
      }
      Map<String, dynamic> body = {};
      return ResponseObject(
          status: true,
          errorObject: null,
          responseObject: Family.fromJson(body));
    } catch (err) {
      print("Error in getFamilies Method. Error: $err ------------------>>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: err,
            errorMessage: err.toString(),
          ));
    }
  }

  Future<ResponseObject> loadUsers() async {
    try {
      //http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/dep_t?&api_key=mzZ58he3
      String path = "$basePath/$table/dep_t?&api_key=$apiKey";
      Uri url = Uri.parse(path);

      http.Response response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode != 200) {
        return ResponseObject(
            status: false,
            errorObject: ErrorObject(
              status: false,
              errorObject: response.body,
              errorMessage: response.body,
            ));
      }

      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> dept = body["dep_t"];

      List<User> users = List.empty(growable: true);
      for (var element in dept) {
        users.add(User.fromJson(element));
      }
      return ResponseObject(
          status: true, errorObject: null, responseObject: users);
    } catch (error) {
      print(
          "Error in getFamilies Method. Error: $error ------------------>>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: error,
            errorMessage: error.toString(),
          ));
    }
  }
}
