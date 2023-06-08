
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../repositories/models/error_object.dart';
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
  String basePath = " ";

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
        "ID: Remover despues, linea 68 en global/api_source.dart------------>>>>>>>>>>>>>> $_hasUserID \n Token: $_token");
    if (_token?.isNotEmpty ?? false) {
      ResponseObject result = Future.value(ResponseObject(status: false)) as ResponseObject;//await getUserInformationByToken();
      if (result.status ?? false) {
        User user = result.responseObject as User;
        _hasUserID.add(HasUserId(userId: "${user.id ?? ""}"));
      } else {
        _hasUserID.stream.drain();
        _hasUserID.add(HasUserId(userId: ""));
        if (kDebugMode) {
          print(result.errorObject?.message);
        }
      }
    } else {
      _hasUserID.add(HasUserId(userId: ""));
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

  Future<ResponseObject> login(
      String username, String password, bool rememberUserName) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      //[ ] http://144.91.124.147:8097/api/login/jsolis/1/0?password=Solis21*
      String path = basePath + "/login/$username/1/1?password=$password";
      Uri url = Uri.parse(path);

      http.Response response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Access-Token": "",
        "User-Agent": "Swagger-Codegen/1.0.0/android"
      });
      if (response.statusCode >= 400) {
        return ResponseObject(
            status: false,
            errorObject: ErrorObject(
                status: false,
                message: response.body,
                errorObject: response,
                errorCode: response.statusCode,
                errorMessage: response.body));
      } else {
        if (rememberUserName) {
          bool containKey = _sharedPreferences!.containsKey("user-name");
          if (containKey) {
            if (await _sharedPreferences!.remove("user-name")) {
              await _sharedPreferences!.setString("user-name", username);
            }
          } else {
            await _sharedPreferences!.setString("user-name", username);
          }
        } else {
          await _sharedPreferences!.remove("user-name");
        }
        String token = response.body.replaceAll("\"", "");

        await updateToken(token, username);

        return ResponseObject(status: true, responseObject: token);
      }
    } catch (error) {
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
              status: false,
              message: error.toString(),
              errorObject: error,
              errorCode: 1404,
              errorMessage: error.toString()));
    }
  }
}