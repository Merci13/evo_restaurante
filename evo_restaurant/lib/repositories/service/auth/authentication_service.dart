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

  Future<ResponseObject> login(bool valid,bool rememberUserName,User userValidation) async {
    ResponseObject result =
        await _api.login(valid, rememberUserName,userValidation);
      if(result.status ?? false){
        userValidation.isLogged = true;
        _userController.add(userValidation);
      }

    return result;
  }

  bool tokenIsNotEmpty() {
    return _api.token != '' && _api.token != null ? true : false;
  }
}
