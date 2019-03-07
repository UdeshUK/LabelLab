import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile/data/config.dart';
import 'package:uuid/uuid.dart';

class Api {
  static const API_SIGN_UP = BASE_URL + "/auth/signup";
  static const API_SIGN_IN = BASE_URL + "/auth/signin";
  static const API_CLASSIFY = BASE_URL + "/classify/image";
  static const API_HISTORY = BASE_URL + "/classify/history";

  final Dio _dio;

  Future<Response> signUp(
      String name, String username, String password, String email) async {
    return _dio.post(API_SIGN_UP, data: {
      "name": name,
      "username": username,
      "password": password,
      "email": email
    });
  }

  Future<Response> signIn(String username, String password) async {
    return _dio
        .post(API_SIGN_IN, data: {"username": username, "password": password});
  }

  Future<Response> uploadImage(String accessToken, File image) async {
    final String uuid = Uuid().v1();

    print(accessToken);
    Map<String, String> headers = {"x-access-token": accessToken};

    FormData formData = new FormData.from({
      "image": new UploadFileInfo(image, uuid),
    });

    return _dio.post(API_CLASSIFY,
        options: Options(
            headers: headers,
            contentType:
                ContentType.parse("application/x-www-form-urlencoded")),
        data: formData);
  }

  Future<Response> getHistory(String accessToken) async {
    print(accessToken);
    Map<String, String> headers = {"x-access-token": accessToken};

    return _dio.get(
      API_HISTORY,
      options: Options(headers: headers),
    );
  }

  // Singleton
  static final Api _api = Api._internal();

  factory Api() {
    return _api;
  }

  Api._internal() : _dio = Dio();
}
