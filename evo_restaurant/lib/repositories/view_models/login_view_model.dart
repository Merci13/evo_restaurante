import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:flutter/cupertino.dart';

import '../../global/error_codes.dart';
import '../../ui/views/widgets/loading/loading_provider.dart';
import '../enums/view_state.dart';
import '../models/error_object.dart';
import '../models/response_object.dart';
import '../models/user.dart';
import '../service/auth/authentication_service.dart';
import 'base_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginViewModel extends BaseModel {
  late AuthenticationService _authenticationService;
  late UserService _userService;
  late BuildContext _context;
  late User _user;
  final formKey = GlobalKey<FormState>();
  bool _flag = true;
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
  String _selectedUser = "";
  List<User> _listOfUser = List.empty(growable: true);

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

  UserService get userService => _userService;

  String get selectedUser => _selectedUser;

  List<User> get listOfUser => _listOfUser;

  User get user => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }

  set listOfUser(List<User> value) {
    _listOfUser = value;
    notifyListeners();
  }

  set selectedUser(String value) {
    _selectedUser = value;
    notifyListeners();
  }

  set userService(UserService value) {
    _userService = value;
  }

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
    if(_flag){
    if (state == ViewState.BUSY) {
      throw ErrorDescription("Finish the process to perform a new one");
    } else {
      setState(ViewState.BUSY);
      try{
        listOfUser.clear();
        selectedUser = "";
        String userNameRemember =
        await authenticationService.getRememberUserName();
        if (userNameRemember != "") {
          _rememberUserName = true;
          _userNameEditingController.text = userNameRemember;
        }
        //charge list of users

        ResponseObject responseObject = await userService.loadUsers();
        bool resultUsers = responseObject.status ?? false;
        if (resultUsers) {
          listOfUser = responseObject.responseObject as List<User>;
          userService.users = listOfUser;

          selectedUser = listOfUser.first.name ?? "";
          errorMessage = "";
        }
        else {

          switch (responseObject.errorObject?.errorCode) {
          //503
            case 503:
              errorMessage = AppLocalizations.of(context)?.unavailableToLoadData ?? "";
              break;

            default:
              errorMessage = AppLocalizations.of(context)?.somethingWentWrongText??"";
          }
        }

        setState(ViewState.IDLE);
        _flag = false;
        notifyListeners();

      }catch(error){
        print("Something went wrong in init method in login_view_model.dart. Error: $error --->>");
        errorMessage = AppLocalizations.of(context)?.somethingWentWrongText ?? "";
        setState(ViewState.IDLE);
      }

    }
    }
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
      User userValidation = User();
      for (User user in _listOfUser) {
        if (user.name?.toLowerCase() == selectedUser.toLowerCase()) {
          userValidation = user;
        }
      }
      String password = passwordEditingController.text;

      ResponseObject result = ResponseObject();

      result = await authenticationService.login(
          password == userValidation.pwd, rememberUserName, userValidation);

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

  selectUser(String value) {
    selectedUser = value;
  }
}
