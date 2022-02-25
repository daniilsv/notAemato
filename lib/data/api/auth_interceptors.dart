import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class AuthInterceptor extends InterceptorsWrapper {
  AuthInterceptor(this.accessToken);
  final ReadWriteValue<String> accessToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // options.headers['version'] = (await PackageInfo.fromPlatform()).version;
    // options.headers['deviceID'] = Env.tempDeviceId;
    // final UserService _user = Get.find<UserService>();
    if (accessToken.val?.isNotEmpty ?? false) {
      options.headers['Authorization'] = 'Bearer ${accessToken.val}';
    }
    handler.next(options);
  }
}
