import 'dart:io';

import 'package:notaemato/data/model/dto/image_upload_response.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UploadApi {
  UploadApi(this.dio);
  Dio? dio;
  Future<ImapeUploadResponse> upload({required String url, File? file}) async {
    final _data = FormData();
    if (file != null) {
      final mim = lookupMimeType(file.path)?.split('/');
      MediaType mt = MediaType('image', 'jpeg');
      if (mim != null) mt = MediaType(mim.first, mim.last);
      _data.files.add(
        MapEntry(
          'file',
          MultipartFile.fromFileSync(
            file.path,
            contentType: mt,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    final _result = await dio!.post<Map<String, dynamic>>(url, data: _data);
    final value = ImapeUploadResponse.fromJson(_result.data!);
    return value;
  }
}
