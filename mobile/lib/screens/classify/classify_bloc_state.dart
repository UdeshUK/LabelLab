import 'package:dio/dio.dart';
import 'package:mobile/modal/classification.dart';

class ClassifyBlocState {
  bool loading;
  DioError error;
  Classification result;

  ClassifyBlocState(this.loading, this.error, this.result);

  ClassifyBlocState.empty() {
    this.loading = false;
    this.error = null;
    this.result = null;
  }
}
