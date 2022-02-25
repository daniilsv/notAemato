import 'package:notaemato/data/model/dto/register_request.dart';
import 'package:notaemato/data/model/dto/register_response.dart';
import 'package:notaemato/data/model/dto/restore_request.dart';
import 'package:notaemato/data/model/dto/restore_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth.g.dart';

@RestApi(baseUrl: '/')
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST("registration/new/")
  Future<RegisterResponse> register(@Body() RegisterRequest dto);

  @POST("registration/recover/")
  Future<RestoreResponse> restore(@Body() RestoreRequest dto);
}
