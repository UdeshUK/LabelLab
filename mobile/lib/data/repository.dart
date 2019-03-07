import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/data/api.dart';
import 'package:mobile/modal/classification.dart';
import 'package:mobile/modal/credential.dart';
import 'package:mobile/modal/user.dart';

class Repository {
  final Api _api;
  String _accessToken;

  Future<bool> loginSilent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    String password = prefs.getString('password');
    if (username != null && password != null) {
      return await _api.signIn(username, password).then((res) {
        print(res);
        _accessToken = res.data["accessToken"];
        return true;
      });
    } else {
      return false;
    }
  }

  Future<bool> login(Credential credential) {
    return _api
        .signIn(credential.username, credential.password)
        .then((res) async {
      print(res);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", credential.username);
      prefs.setString("password", credential.password);
      _accessToken = res.data["accessToken"];
      return true;
    });
  }

  Future<bool> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = null;
    prefs.setString("username", null);
    prefs.setString("password", null);
    return true;
  }

  Future<bool> signUp(User user) {
    return _api
        .signUp(user.name, user.username, user.password, user.email)
        .then((res) {
      print(res);
      return true;
    }).catchError((err) {
      print(err);
    });
  }

  Future<Classification> classify(File image) {
    if (_accessToken != null) {
      return _api
          .uploadImage(_accessToken, image)
          .then((res) => Classification.fromJson(res.data));
    } else {
      throw Exception("No access token");
    }
  }

  Future<List<Classification>> history() {
    if (_accessToken != null) {
      return _api
          .getHistory(_accessToken)
          .then((res) => (res.data as List).map((i) {
                return Classification.fromJson(i);
              }).toList());
    } else {
      throw Exception("No access token");
    }
  }

  // Singleton
  static final Repository _repository = Repository._internal();

  factory Repository() {
    return _repository;
  }

  Repository._internal() : _api = Api();
}
