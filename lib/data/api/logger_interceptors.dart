import 'package:dio/dio.dart';
import 'package:notaemato/app/logger.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String headers =
        options.headers.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    logger.i('-> ${options.method} ${options.uri}\n$headers');
    silentLogger.i('-> ${options.data?.toString() ?? ''}');
    handler.next(options);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    final String headers =
        response.headers.map.entries.map((e) => '<- ${e.key}: ${e.value}').join('\n');
    Level level = Level.info;
    if (response.statusCode == null || response.statusCode! >= 500)
      level = Level.debug;
    else if (response.statusCode! >= 400)
      level = Level.error;
    else if (response.statusCode! > 300) level = Level.warning;
    silentLogger.log(level, '<- ${response.statusCode} ${response.realUri}\n$headers');
    silentLogger.log(level, response.data);
    silentLogger.log(level, '<- END');
    handler.next(response);
  }
}
