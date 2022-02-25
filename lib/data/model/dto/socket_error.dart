import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'socket_error.g.dart';

@JsonSerializable(createToJson: false)
@immutable
class SocketError {
  final int? error;
  final String? reason;

  const SocketError({
    this.error,
    this.reason,
  });
  static const SocketError noInternet = SocketError(error: 100, reason: 'No internet');
  static const SocketError invalidRequest =
      SocketError(error: 9001, reason: 'Invalid request');

  factory SocketError.fromJson(Map<String, dynamic> json) => _$SocketErrorFromJson(json);

  @override
  bool operator ==(Object o) => o is SocketError && error == o.error;
  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'SocketError: $error "$reason"';
}
