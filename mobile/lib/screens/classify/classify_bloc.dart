import 'dart:async';
import 'dart:io';

import 'package:mobile/bloc/base_bloc.dart';
import 'package:mobile/bloc/bloc_state.dart';
import 'package:mobile/modal/classification.dart';

class ClassifyBloc extends BaseBloc {
  BlocState<Classification> _currentState = BlocState<Classification>.empty();

  final _classifyController = StreamController<BlocState<Classification>>();
  Stream<BlocState<Classification>> get classifyStream =>
      _classifyController.stream;

  classifyImage(File image) {
    _currentState.loading = true;
    _currentState.error = null;
    _currentState.result = null;
    _classifyController.add(_currentState);
    repository.classify(image).then((Classification res) {
      _currentState.loading = false;
      _currentState.result = res;
      _classifyController.add(_currentState);
    }).catchError((err) {
      _currentState.loading = false;
      _currentState.error = err;
      _classifyController.add(_currentState);
    });
  }

  @override
  void onDispose() {
    _classifyController.close();
  }
}
