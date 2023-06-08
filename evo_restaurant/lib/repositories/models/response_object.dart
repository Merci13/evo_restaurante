import 'package:evo_restaurant/repositories/models/error_object.dart';

class ResponseObject {
  bool? status = false;
  Object? responseObject = Object();

  ErrorObject? errorObject = ErrorObject();

  ResponseObject({this.status, this.responseObject, this.errorObject});

  ResponseObject.init()
      : status = false,
        errorObject = ErrorObject(),
        responseObject = null;



}
