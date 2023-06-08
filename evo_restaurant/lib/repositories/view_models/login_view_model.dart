import 'package:flutter/cupertino.dart';

import '../../global/error_codes.dart';
import '../../ui/views/widgets/loading/loading_provider.dart';
import '../enums/view_state.dart';
import '../models/error_object.dart';
import '../models/response_object.dart';
import '../service/auth/authentication_service.dart';
import 'base_model.dart';


class LoginViewModel extends BaseModel {
  late AuthenticationService _authenticationService;
  late BuildContext _context;
  FocusNode _userNameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _scaffoldFocusNode = FocusNode();
  TextEditingController _userNameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  bool _showPassword = false;
  bool _rememberUserName = false;
  String _errorMessage = "";
  late LoadingProvider _loadingProvider;
  bool _showLoading = false;

  AuthenticationService get authenticationService => _authenticationService;

  BuildContext get context => _context;

  FocusNode get passwordFocusNode => _passwordFocusNode;

  FocusNode get userNameFocusNode => _userNameFocusNode;

  TextEditingController get passwordEditingController =>
      _passwordEditingController;

  TextEditingController get userNameEditingController =>
      _userNameEditingController;

  bool get showPassword => _showPassword;

  bool get rememberUserName => _rememberUserName;

  String get errorMessage => _errorMessage;

  LoadingProvider get loadingProvider => _loadingProvider;

  FocusNode get scaffoldFocusNode => _scaffoldFocusNode;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    notifyListeners();
  }

  set scaffoldFocusNode(FocusNode value) {
    _scaffoldFocusNode = value;
    notifyListeners();
  }

  set loadingProvider(LoadingProvider value) {
    _loadingProvider = value;
  }

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  set rememberUserName(bool value) {
    _rememberUserName = value;
    notifyListeners();
  }

  set showPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  set userNameEditingController(TextEditingController value) {
    _userNameEditingController = value;
    notifyListeners();
  }

  set passwordEditingController(TextEditingController value) {
    _passwordEditingController = value;
    notifyListeners();
  }

  set userNameFocusNode(FocusNode value) {
    _userNameFocusNode = value;
    notifyListeners();
  }

  set passwordFocusNode(FocusNode value) {
    _passwordFocusNode = value;
    notifyListeners();
  }

  set authenticationService(AuthenticationService value) {
    _authenticationService = value;
    notifyListeners();
  }

  set context(BuildContext value) {
    _context = value;
    notifyListeners();
  }

  init(BuildContext context) async {
    String userNameRemember = await authenticationService.getRememberUserName();
    if (userNameRemember != "") {
      _rememberUserName = true;
      _userNameEditingController.text = userNameRemember;
    }

    notifyListeners();
  }

  bool isUserNameFocused() {
    return true;
  }

  void setRememberName(bool? value) {
    rememberUserName = value ?? false;
  }

  void removeFocus() {
    FocusScope.of(context).unfocus();
  }

  Future<ResponseObject> login() async {
    try {
      if (state == ViewState.BUSY) {
        throw ErrorDescription("Finish the process to perform a new one");
      }
      setState(ViewState.BUSY);
      String username = userNameEditingController.text;
      String password = passwordEditingController.text;
      ResponseObject result = await authenticationService.login(
          username, password, rememberUserName);
      setState(ViewState.IDLE);
      return result;
    } catch (error) {
      return ResponseObject(
        status: false,
        errorObject: ErrorObject(
            status: false,
            errorMessage: "Something went Wrong",
            errorCode: errorSomethingWentWrong,
            message: "Something went Wrong"),
      );
    }
  }
}