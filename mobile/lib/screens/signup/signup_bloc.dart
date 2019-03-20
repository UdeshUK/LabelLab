import 'dart:async';

import 'package:mobile/bloc/base_bloc.dart';
import 'package:mobile/bloc/bloc_state.dart';
import 'package:mobile/modal/user.dart';

class SignupBloc extends BaseBloc {
  BlocState<bool> _currentState = BlocState<bool>.empty();

  final _signupController = StreamController<BlocState<bool>>();
  Stream<BlocState<bool>> get signupStream => _signupController.stream;

  final _signupSuccessController = StreamController<bool>();
  Stream<bool> get signupSuccessStream => _signupSuccessController.stream;

  signup(User user) {
    _currentState.loading = true;
    _currentState.error = null;
    _currentState.result = null;
    _signupController.add(_currentState);
    repository.signUp(user).then((bool res) {
      print("signUp res");
      print(res);
      if (res != null && res) {
        _signupSuccessController.add(true);
      } else {
        _currentState.loading = false;
        _currentState.error = null;
        _currentState.result = false;
        _signupController.add(_currentState);
      }
    }).catchError((err) {
      _currentState.loading = false;
      _currentState.error = err;
      _signupController.add(_currentState);
    });
  }

  @override
  void onDispose() {
    print("dispose");
    _signupController.close();
    _signupSuccessController.close();
  }
}
