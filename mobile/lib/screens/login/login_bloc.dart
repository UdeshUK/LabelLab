import 'dart:async';

import 'package:mobile/bloc/base_bloc.dart';
import 'package:mobile/bloc/bloc_state.dart';
import 'package:mobile/modal/credential.dart';

class LoginBloc extends BaseBloc {
  BlocState<bool> _currentState = BlocState<bool>.empty();

  final _loginController = StreamController<BlocState<bool>>();
  Stream<BlocState<bool>> get loginStream => _loginController.stream;

  final _loginSuccessController = StreamController<bool>();
  Stream<bool> get loginSuccessStream => _loginSuccessController.stream;

  loginSilent() {
    _currentState.loading = true;
    _currentState.error = null;
    _currentState.result = false;
    _loginController.add(_currentState);
    repository.loginSilent().then((bool res) {
      if (res != null && res) {
        _loginSuccessController.add(res);
      } else {
        _currentState.loading = false;
        _currentState.error = null;
        _currentState.result = false;
        _loginController.add(_currentState);
      }
    }).catchError((err) {
      _currentState.loading = false;
      _currentState.error = err;
      _loginController.add(_currentState);
    });
  }

  login(Credential credential) {
    _currentState.loading = true;
    _currentState.error = null;
    _currentState.result = null;
    _loginController.add(_currentState);
    repository.login(credential).then((bool res) {
      if (res) {
        print("Loggin");
        _loginSuccessController.add(true);
      } else {
        _currentState.loading = false;
        _currentState.error = null;
        _currentState.result = false;
        _loginController.add(_currentState);
      }
    }).catchError((err) {
      _currentState.loading = false;
      _currentState.error = err;
      _loginController.add(_currentState);
    });
  }

  @override
  void onDispose() {
    print("dispose");
    _loginController.close();
    _loginSuccessController.close();
  }
}
