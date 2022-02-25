import 'dart:io';

import 'package:notaemato/data/repository/user.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

import '../../env.dart';
import 'auth.dart';
import 'logger_interceptors.dart';
import 'upload.dart';

@singleton
class Api {
  Api(UserRepository _userRepository) {
    dio = Dio()
      ..httpClientAdapter = (DefaultHttpClientAdapter()
        ..onHttpClientCreate = (httpClient) {
          return httpClient
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
        })
      ..interceptors.addAll([
        // AuthInterceptor(_authRepository),
        LoggerInterceptor(),
      ]);
    stage = _userRepository.stage;
    onStageChange();
    stage.listen((_) => onStageChange());
  }
  late Dio dio;
  late AuthApi auth;
  late UploadApi upload;
  late ReadWriteValue<String?> stage;

  void onStageChange() {
    final baseUrl = Env.restUrl[stage.val ?? 'prod'];
    auth = AuthApi(dio, baseUrl: baseUrl);
    upload = UploadApi(dio);
  }
}
