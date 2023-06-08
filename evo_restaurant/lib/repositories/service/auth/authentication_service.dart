import 'dart:async';

import '../../../global/api_source.dart';
import '../../models/response_object.dart';
import '../../models/user.dart';

class AuthenticationService {
  StreamController<User> _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;
  late ApiSource _api;
  String lastErrorMessage = "";

  set api(ApiSource value) {
    _api = value;
  }

  updateUser(User user) {
    _userController.add(user);
  }

  ///dispose Method
  dispose() {
    _userController.close();
  }

  Future<String> getRememberUserName() async {
    return _api.getRememberUserName();
  }

  Future<ResponseObject> login(
      String username, String password, bool rememberUserName) async {
    ResponseObject result =
        await _api.login(username, password, rememberUserName);
    if (result.status ?? false) {
      ResponseObject getUserInformation =
          Future.value(ResponseObject(status: false))
              as ResponseObject;
      //await _api.getUserInformation(
      // result.responseObject as String, username);

      bool resultGetUserInformation = getUserInformation.status ?? false;
      if (resultGetUserInformation) {
        _userController.add(getUserInformation.responseObject as User);
      } else {
        result = ResponseObject(
          status: false,
          errorObject: getUserInformation.errorObject,
        );
      }
    }

    return result;
  }

  bool tokenIsNotEmpty() {
    return _api.token != '' && _api.token != null ? true : false;
  }
}
