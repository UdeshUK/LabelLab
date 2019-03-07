import 'package:mobile/bloc/base_bloc.dart';
import 'package:mobile/modal/classification.dart';

class HomeBloc extends BaseBloc {
  Future<List<Classification>> history() {
    return repository.history();
  }

  Future<bool> logout() {
    return repository.logout();
  }

  @override
  void onDispose() {}
}
