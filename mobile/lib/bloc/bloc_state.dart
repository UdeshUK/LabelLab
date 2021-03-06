import 'package:dio/dio.dart';

class BlocState<T> {
  bool loading;
  dynamic error;
  T result;

  BlocState(this.loading, this.error, this.result);

  BlocState.empty() {
    this.loading = false;
    this.error = null;
    this.result = null;
  }
}
