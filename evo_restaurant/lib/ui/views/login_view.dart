import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/enums/view_state.dart';
import 'package:evo_restaurant/repositories/models/error_object.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/ui/views/widgets/loading/loading_provider.dart';
import 'package:evo_restaurant/utils/share/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../global/error_codes.dart';
import '../../repositories/models/response_object.dart';
import '../../repositories/models/user.dart';
import '../../repositories/service/auth/authentication_service.dart';
import '../../repositories/view_models/base_widget_model.dart';
import '../../repositories/view_models/login_view_model.dart';
import '../../utils/share/ui_helpers.dart';
import 'widgets/information_modal/information_modal.dart';

part 'login_view.g.dart';

class LoginView extends BaseWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    //var platform = Theme.of(context).platform;
    return ChangeNotifierProxyProvider3<UserService, AuthenticationService,
        LoadingProvider, LoginViewModel>(
      create: (_) => LoginViewModel(),
      update: (_, userService, authenticationService, loadingProvider, model) =>
          (model ?? LoginViewModel())
            ..authenticationService = authenticationService
            ..userService = userService
            ..context = context
            ..loadingProvider = loadingProvider
            ..init(context),
      child: Consumer<LoginViewModel>(
        builder: (context, model, _) {
          Size mediaQuery = MediaQuery.of(context).size;
          // var data = MediaQuery.of(context).viewPadding;

          return SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: GestureDetector(
              onTap: () {
                if (MediaQuery.of(context).viewInsets.bottom != 0) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _ContainerOfLogo(),
                      UIHelper.verticalSpace(mediaQuery.height * 0.07),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)?.loginText ?? "",
                          style: TextStyle(
                              // fontFamily: commonFamily,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                              fontSize: 20),
                        ),
                      ),
                      UIHelper.verticalSpace(mediaQuery.height * 0.017),
                      const _FormContainer(),
                      UIHelper.verticalSpace(mediaQuery.height * 0.017),
                     // const _RememberUserCheckBoxContainer(),
                      UIHelper.verticalSpace(mediaQuery.height * 0.10),
                      const _ButtonEnterContainer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

@swidget
Widget __buttonEnterContainer(BuildContext context) {
  return Consumer2<LoginViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      Size mediaQuery = MediaQuery.of(context).size;
      return SizedBox(
        width: mediaQuery.width * 0.40,
        height: mediaQuery.height * 0.07,
        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            enableFeedback: false,
            elevation: 3,
            alignment: Alignment.center,
            backgroundColor: Colors.blue[900],
          ),
          child: Text(
            AppLocalizations.of(context)?.loginText?? "",
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          onPressed: () async {
            baseWidgetModel.showOverLayWidget(
              true,
              const InformationModal.loading(
                typeInformationModal: TypeInformationModal.LOADING,
              ),
            );
            ResponseObject result = await model.login();
            baseWidgetModel.showOverLayWidget(false, Container());
            bool res = result.status ?? false;
            if (!res) {
              ErrorObject errorObject = result.errorObject ?? ErrorObject();
              baseWidgetModel.showOverLayWidget(
                  true,
                  InformationModal(
                    typeInformationModal: TypeInformationModal.WARNING,
                    icon: Icon(
                      Icons.warning,
                      color: Colors.yellow[700],
                      size: 40,
                    ),
                    acceptButton: () {
                      baseWidgetModel.showOverLayWidget(false, Container());
                    },
                    title: AppLocalizations.of(context)?.warningText?? "",
                    contentText:
                        errorObject.errorCode == errorPasswordIsNotCorrect
                            ? AppLocalizations.of(context)?.passwordIsNotCorrectText ?? ""
                            : AppLocalizations.of(context)?.somethingWentWrongText ??"",
                  ));
            }
          },
        ),
      );
    },
  );
}

@swidget
Widget __rememberUserCheckBoxContainer(BuildContext context) {
  return Consumer<LoginViewModel>(
    builder: (context, model, _) {
      Size mediaQuery = MediaQuery.of(context).size;
      return SizedBox(
        width: mediaQuery.width * 0.20,
        height: mediaQuery.height * 0.07,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 30,
                child: Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.grey,
                  value: model.rememberUserName,
                  onChanged: (value) {
                    model.setRememberName(value);
                  },
                )),
            Expanded(
                flex: 70,
                child: Text(
                  AppLocalizations.of(context)?.rememberUserNameText ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ))
          ],
        ),
      );
    },
  );
}

@swidget
Widget __formContainer(BuildContext context) {
  return Consumer<LoginViewModel>(
    builder: (context, model, _) {
      final formKey = GlobalKey<FormState>();
      return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const _UsersDropDown(),
            UIHelper.verticalSpace(10),
            const _PasswordTextFormField(),
          ],
        ),
      );
    },
  );
}

@swidget
Widget __usersDropDown(BuildContext context) {
  return Consumer2<LoginViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel,_) {
      Size mediaQuery = MediaQuery.of(context).size;
      if(model.state == ViewState.IDLE){
        if(model.errorMessage != ""){
          baseWidgetModel.showOverLayWidget(true,
          InformationModal(
              typeInformationModal: TypeInformationModal.ERROR,
              title: AppLocalizations.of(context)?.errorText ?? "",
              contentText: model.errorMessage,
              acceptButton: (){
                model.errorMessage = "";
                baseWidgetModel.showOverLayWidget(false, Container());
              },
              icon: Icon(Icons.error_outlined, color: Colors.red[800], size: 40,))
          );
        }
      }
      return Container(
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.05),
          height: mediaQuery.height * 0.06,
          width: mediaQuery.width * 0.40,
          decoration: BoxDecoration(
              color: Colors.white,
              //background color of dropdown button
              border: Border.all(color: colorPrimary, width: 1),
              //border of dropdown button
              borderRadius: BorderRadius.circular(7),
              //border raiuds of dropdown button
              boxShadow: UIHelper.boxShadowHelper),
          child: model.listOfUser.isEmpty
              ? Container()
              : DropdownButton(
                  isDense: true,
                  isExpanded: true,
                  padding: const EdgeInsets.only(top: 10),
                  elevation: 0,
                  value: model.selectedUser,
                  onChanged: (value) {
                    model.selectUser(value ?? "");
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: colorPrimary,
                    size: 25,
                  ),
                  items: model.listOfUser.map((User value) {
                    return DropdownMenuItem<String>(
                        value: value.name,
                        child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text(
                              value.name?.toUpperCase() ?? "",
                              textAlign: TextAlign.center,
                            )));
                  }).toList(),
                ));
    },
  );
}

@swidget
Widget __passwordTextFormField(BuildContext context) {
  return Consumer<LoginViewModel>(
    builder: (context, model, _) {
      Size mediaQuery = MediaQuery.of(context).size;
      return SizedBox(
        height: mediaQuery.height * 0.06,
        width: mediaQuery.width * 0.40,
        child: TextFormField(
          focusNode: model.passwordFocusNode,
          controller: model.passwordEditingController,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          obscureText: !model.showPassword,
          onTap: () {
            if (!model.passwordFocusNode.hasFocus) {
              model.passwordFocusNode.requestFocus();
            }
          },
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.passwordText ?? "",
              labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
              prefixIcon: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  FontAwesomeIcons.lock,
                  color: Colors.grey,
                ),
              ),
              suffixIcon: Container(
                padding: const EdgeInsets.all(10),
                child: model.showPassword
                    ? IconButton(
                        icon: const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          model.showPassword = !model.showPassword;
                        })
                    : IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          model.showPassword = !model.showPassword;
                        }),
              ),
              hintText: AppLocalizations.of(context)?.enterPasswordHintText ?? "",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Colors.blue[900] ?? Colors.blue),
              ),
              hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 2, color: Colors.blue[900] ?? Colors.blue)),
              filled: true,
              contentPadding: const EdgeInsets.all(16),
              fillColor: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)?.enterACorrectUserNameText ?? "";
            }
            return null;
          },
        ),
      );
    },
  );
}

@swidget
Widget __containerOfLogo(BuildContext context) {
  Size mediaQuery = MediaQuery.of(context).size;
  var data = MediaQuery.of(context).viewPadding;
  return Column(
    children: [
      UIHelper.verticalSpace(data.top + 25),
      SizedBox(
        height: mediaQuery.height * 0.25,
        width: mediaQuery.width * 0.50,
        child: Image.asset("assets/evo_icon.png" //image route here,
            ),
      ),
      UIHelper.verticalSpace(10),
      Text(
        'Evo Restaurante'.toUpperCase(),
        style: TextStyle(
            fontSize: 28,
            fontFamily: 'FontAwesome-otf',
            fontWeight: FontWeight.bold,
            color: Colors.grey[600]),
      )
    ],
  );
}
