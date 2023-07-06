import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';

import '../models/user.dart';


class HomeViewModel extends BaseModel{

  late User _user;
  late UserService _userService;

  UserService get userService => _userService;


  User get user => _user;

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