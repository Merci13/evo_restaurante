import 'package:evo_restaurant/repositories/models/hall.dart';
import 'package:evo_restaurant/repositories/models/user.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';

class HallViewModel extends BaseModel {
  late User _user;
  late UserService _userService;
  late HallService _hallService;

  late Hall _hall;

  User get user => _user;

  UserService get userService => _userService;

  HallService get hallService => _hallService;

  Hall get hall => _hall;

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

  init() {
    notifyListeners();
  }
}
