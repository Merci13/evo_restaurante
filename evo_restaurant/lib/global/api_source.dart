// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:evo_restaurant/global/config.dart';
import 'package:evo_restaurant/repositories/models/command_table.dart';
import 'package:evo_restaurant/repositories/models/hall.dart';
import 'package:evo_restaurant/repositories/models/sub_family.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../repositories/models/article.dart';
import '../repositories/models/error_object.dart';
import '../repositories/models/family.dart';
import '../repositories/models/response_object.dart';
import '../repositories/models/table_detail.dart';
import '../repositories/models/user.dart';
import '../repositories/models/table.dart' as own_table;
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
      ResponseObject result = await Future.value(
          ResponseObject(status: false)); //await getUserInformationByToken();

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
      print(
          "Error in method updateToken in api_source. Error: $error --------------------->>>>>>>>>>");
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
      bool valid, bool rememberUserName, User userValidation) async {
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
              await _sharedPreferences!
                  .setString("user-name", userValidation.name ?? "");
            }
          } else {
            await _sharedPreferences!
                .setString("user-name", userValidation.name ?? "");
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

  ///
  /// Call the API to obtain the families as representation in JSON format.
  /// Then, it takes the JSON and transform in an Object List called Family, and
  /// send it back in the ResponseObject.
  /// If something went wrong it will return an ErrorObject in the ResponseObject
  /// with the body of the JSON
  ///
  ///
  Future<ResponseObject> getFamilies() async {
    try {
      //http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/fam_m?[off]=0&api_key=mzZ58he3
      String path = "$basePath/$table/fam_m?[off]=0&api_key=$apiKey";
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
      List<Family> list = List.empty(growable: true);

      body.forEach((key, value) {
        if (key == "fam_m") {
          for (var element in (value as List<dynamic>)) {
            list.add(Family.fromJson(element));
          }
        }
      });
      for (var element in list) {
        element.image = imageFromBase64String(element.img ?? "");
      }

      return ResponseObject(
          status: true, errorObject: null, responseObject: list);
    } catch (err) {
      print("Error in api_source.dart file, in getFamilies Method. Error: $err ------------------>>>>");
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
                errorCode: response.statusCode));
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

  Future<ResponseObject> getAllHalls() async {
    try {
      String path = "$basePath/$table/sal_T?&api_key=$apiKey";
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
      List<dynamic> dept = body["sal_t"];

      List<Hall> halls = List.empty(growable: true);
      for (var element in dept) {
        halls.add(Hall.fromJson(element));
      }
      return ResponseObject(
          status: true, errorObject: null, responseObject: halls);
    } catch (error) {
      print(
          "Error in api_source.dart. Error in method getAllHalls. Error: $error -------->>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: error,
            errorMessage: error.toString(),
          ));
    }
  }

  Future<ResponseObject> getAllTablesFromHall(Hall hall) async {
    try {
      String path =
          "$basePath/$table/mes_t?filter[sal]=${hall.id}&api_key=$apiKey";
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
                errorObject: "Error", //response.body,
                errorMessage: "Error" //response.body,
                ));
      }

      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> dept = body["mes_t"];

      List<own_table.Table> halls = List.empty(growable: true);
      for (var element in dept) {
        halls.add(own_table.Table.fromJson(element));
      }
      return ResponseObject(
          status: true, errorObject: null, responseObject: halls);
    } catch (error) {
      print(
          "Error in api_source.dart in method getAllTablesFromHall. Error: $error ------->>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: error,
            errorMessage: error.toString(),
          ));
    }
  }

  Future<ResponseObject> getTable(own_table.Table tableGet) async {
    try {
      String path =
          "$basePath/$table/FAC_APA_LIN_T??filter[mes_t]=${tableGet.id}&api_key=$apiKey";
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
      TableDetail tableDetail = TableDetail.fromJson(body);

      return ResponseObject(
          status: true, errorObject: null, responseObject: tableDetail);
    } catch (error) {
      print(
          "Error in api_source.dart in method getTable. Error: $error ------->>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: error,
            errorMessage: error.toString(),
          ));
    }
  }

  Future<ResponseObject> getSubfamily(Family family) async {
    try {
      //http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/_process/TPV_CAR_FAM_II_API?param[ID_FAM]=10&api_key=mzZ58he3
      String path =
          "$basePath/$table/_process/TPV_CAR_FAM_II_API?param[ID_FAM]=${family.id}&api_key=$apiKey";
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

      List<SubFamily> temp = List.empty(growable: true);
      for (var element in (body["fam_m"] as List)) {
        temp.add(SubFamily.fromJson(element));
      }
      for (var element in temp) {
        element.image = imageFromBase64String(element.img ?? '');
      }

      return ResponseObject(
          status: true, errorObject: null, responseObject: temp);
    } catch (error) {
      print(
          "Error in api_source.dart in method getSubFamily. Error: $error ------->>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: error,
            errorMessage: error.toString(),
          ));
    }
  }

  Future<ResponseObject> getArticlesOfSubfamily(
    String idSubFamily,
  ) async {
    try {
      String
          path = //http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/art_m?filter[fam]=10&api_key=mzZ58he3
          "$basePath/$table/art_m?filter[fam]=$idSubFamily&api_key=$apiKey";
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
      List<Article> list = List.empty(growable: true);

      for (var element in (body["art_m"] as List)) {
        list.add(Article.fromJson(element));
      }
      for (var element in list) {
        element.image = imageFromBase64String(element.img ?? '');
      }

      return ResponseObject(
          status: true, errorObject: null, responseObject: list);
    } catch (error) {
      print(
          "Error in api_source.dart in method getArticlesOfSubfamily. Error: $error ------->>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: error,
            errorMessage: error.toString(),
          ));
    }
  }


  ///
  /// Return a List of Articles in the ResponseObject from de API
  /// Error: returns a ErrorObject in the ResponseObject
  ///
  Future<ResponseObject> getAllArticles() async{
    //209.145.58.91/Pruebas/vERP_2_dat_dat/v1/art_m?&api_key=mzZ58he3
    try {
      String
      path =
          "$basePath/$table/art_m?&api_key=$apiKey";
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
      List<Article> list = List.empty(growable: true);

      for (var element in (body["art_m"] as List)) {
        list.add(Article.fromJson(element));
      }
      for (var element in list) {
        element.image = imageFromBase64String(element.img ?? '');
      }

      return ResponseObject(
          status: true, responseObject: list, errorObject: null);
    } catch (error) {
      print(
          "Error in api_source.dart in method getAllArticles. Error: $error ------->>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: "error",
            errorMessage: "",
          ));
    }

  }





  Future<ResponseObject> getArticlesOfFamily(Family family) async {
    try {
      String
          path = //http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/art_m?filter[fam]=10&api_key=mzZ58he3
          "$basePath/$table/art_m?filter[fam]=${family.id}&api_key=$apiKey";
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
      List<Article> list = List.empty(growable: true);

      for (var element in (body["art_m"] as List)) {
        list.add(Article.fromJson(element));
      }
      for (var element in list) {
        element.image = imageFromBase64String(element.img ?? '');
      }

      return ResponseObject(
          status: true, responseObject: list, errorObject: null);
    } catch (error) {
      print(
          "Error in api_source.dart in method getArticlesOfFamily. Error: $error ------->>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: "error",
            errorMessage: "",
          ));
    }
  }
  Future<ResponseObject> senCommand(List<CommandTable> listOfCommand, String idTable) async {
    try{
///ToDo check this method to send the command line
      String path =
          "$basePath/$table/FAC_APA_LIN_T??filter[mes_t]=$idTable&api_key=$apiKey";


      Uri url = Uri.parse(path);
      for(CommandTable commandTable in listOfCommand){
        http.Response response = await http.put(url, headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",

        },
          body: CommandTable.toJsonLine(commandTable),
        );
        if(response.statusCode != 200){
          return ResponseObject(
              status: false,
              errorObject: ErrorObject(
                status: false,
                errorObject: response.body,
                errorMessage: "${response.body} Problem line ${commandTable.id} or article id ${commandTable.idArt}",
              ));
        }
      }
        return ResponseObject(
          responseObject: "",
          status: true,
        );


    }catch(error){

      print(
          "Error in api_source.dart in method senCommand. Error: $error ------->>>>");
      return ResponseObject(
          status: false,
          errorObject: ErrorObject(
            status: false,
            errorObject: "error",
            errorMessage: "$error",
          ));
    }

  }



  //-------------------------------------------------------------//

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }



//-------------------------------------------------------------//
}
