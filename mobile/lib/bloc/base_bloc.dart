import 'package:mobile/data/repository.dart';

abstract class BaseBloc {
  final Repository repository = Repository();

  void onDispose();
}
