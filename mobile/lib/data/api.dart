import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile/data/config.dart';
import 'package:uuid/uuid.dart';

class API {
  // static const API_CLASSIFY = BASE_URL + "/classify/image";
  static const API_CLASSIFY = BASE_URL + "/upload";

  final Dio _dio;

  Future<Response> uploadImage(File image) async {
    final String uuid = Uuid().v1();

    FormData formData = new FormData.from({
      "image": new UploadFileInfo(image, uuid),
    });
    return _dio.post(API_CLASSIFY, data: formData);
  }

  // Singleton
  static final API _api = API._internal();

  factory API() {
    return _api;
  }

  API._internal() : _dio = Dio();
}
