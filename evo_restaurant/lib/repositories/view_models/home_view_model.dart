import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_model.dart';

import '../models/user.dart';

class HomeViewModel extends BaseModel {
  late User _user;
  late UserService _userService;
  List<String> _listOfHalls = List.empty(growable: true);

  UserService get userService => _userService;

  User get user => _user;

  List<String> get listOfHalls => _listOfHalls;

  set listOfHalls(List<String> value) {
    _listOfHalls = value;
  }

  set user(User value) {
    _user = value;
  }

  set userService(UserService value) {
    _userService = value;
  }

  init() {
    try {
      listOfHalls.clear();
      //call the method to get all halls
      fillHalls(); // ToDo change this method to call the API to get the list of halls.

      notifyListeners();
    } catch (error) {
      print("Error in HomeViewModel. Error: $error -------->>>");
    }
  }

  void fillHalls() {
    for (int i = 0; i < 20; i++) {
      listOfHalls.add("Hall #$i");
    }
  }
}
