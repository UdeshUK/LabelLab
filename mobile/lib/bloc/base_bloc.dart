import 'package:mobile/data/api.dart';

abstract class BaseBloc {
  final API api = API();

  void onDispose();
}
