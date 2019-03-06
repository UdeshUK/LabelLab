import 'package:mobile/bloc/base_bloc.dart';

class HomeBloc extends BaseBloc {

  Future<bool> logout() {
    return repository.logout();
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
  }
  
}