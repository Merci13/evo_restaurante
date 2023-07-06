

import 'package:evo_restaurant/repositories/models/user.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';

class AppBarViewModel extends BaseModel{
  late User _user;
  late UserService _userService;

  User get user => _user;
  UserService get userService => _userService;

  set user(User value) {
    _user = value;
  }
  set userService(UserService value) {
    _userService = value;
  }

  init(){
    notifyListeners();
  }
}