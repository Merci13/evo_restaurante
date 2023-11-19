import '../../../global/api_source.dart';
import '../../models/response_object.dart';
import '../../models/user.dart';

class UserService {
  late ApiSource _api;

  late List<User> _users = List.empty(growable: true);

  set api(ApiSource value) {
    _api = value;
  }

  set users(List<User> value) {
    _users = value;
  }

  Future<ResponseObject> logOut() async {
    return Future.value(ResponseObject(status: false)); //_api.logOut();
  }

  Future<ResponseObject> loadUsers() async {
    return await _api.loadUsers();
  }

  bool checkPassword(String password) {
    try{
      bool res = false;
      for(User user in _users){
        if(user.supDep ?? false){
           if((user.pwd ?? "") == password){
             res = true;
           }
        }
      }
      return res;

    }catch(error){
      print("Error in user_service.dart in method checkPassword. Error: $error -------->>>");
      return false;
    }
  }
}
