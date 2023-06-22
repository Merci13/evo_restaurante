

import '../../../global/api_source.dart';
import '../../models/response_object.dart';

class UserService{
  late ApiSource _api;

  set api(ApiSource value) {
    _api = value;
  }

  Future<ResponseObject> logOut() async {
    return Future.value(ResponseObject(status: false));//_api.logOut();


  }

  Future<ResponseObject> loadUsers()async {
    return _api.loadUsers();
  }


}