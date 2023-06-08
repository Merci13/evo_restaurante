class ErrorObject {
  String? errorMessage = "";
  String? message = "";
  bool? status = false;
  Object? errorObject = Object();
  int? errorCode = 0;

  ErrorObject(
      {this.errorMessage,
      this.message,
      this.status,
      this.errorObject,
      this.errorCode});

  ErrorObject.initial()
      : errorMessage = "",
        message = "",
        status = false,
        errorObject = null,
        errorCode = 0;
}
