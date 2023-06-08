import 'package:flutter/cupertino.dart';

import '../enums/view_state.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;
  bool showErrorStatus = false;
  bool _mounted = true;

  bool get mounted => _mounted;

  ViewState get state => _state;

  ///Change state
  void setState(ViewState viewState) {
    _state = viewState;
    if (mounted) {
      notifyListeners();
    }
  }

  ///Dispose method
  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}
