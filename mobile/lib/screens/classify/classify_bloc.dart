import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile/bloc/base_bloc.dart';
import 'package:mobile/modal/classification.dart';
import 'package:mobile/screens/classify/classify_bloc_state.dart';

class ClassifyBloc extends BaseBloc {
  ClassifyBlocState _currentState = ClassifyBlocState.empty();

  final _classifyController = StreamController<ClassifyBlocState>();
  Stream<ClassifyBlocState> get classifyStream => _classifyController.stream;

  classifyImage(File image) {
    _currentState.loading = true;
    _currentState.error = null;
    _currentState.result = null;
    _classifyController.add(_currentState);
    api.uploadImage(image).then((Response res) {
      _currentState.loading = false;
      print(res.data['size']);
      _currentState.result = Classification.fromJson(res.data);
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
