import 'package:notaemato/env.dart';
import 'package:appmetrica_sdk/appmetrica_sdk.dart';

class MetricaService {
  static MetricaService? _instance;
  static final metricaAppEvents = AppmetricaSdk();

  factory MetricaService() {
    return _instance ??= MetricaService._();
  }
  MetricaService._() {
    init();
  }

  Future<void> init() async {
    await metricaAppEvents.activate(apiKey: Env.metricaKey);
  }

  static Future<void> event(String event, [Map<String, dynamic>? data]) async {
    data?.removeWhere((key, value) => value == null);
    try {
      Future.wait([
        metricaAppEvents.reportEvent(name: event, attributes: data),
      ]);
      // ignore: empty_catches
    } on Object {} finally {}
  }

  static Future<void> setUser(int id) async {
    try {
      Future.wait([
        metricaAppEvents.setUserProfileID(userProfileID: id.toString()),
      ]);
      // ignore: empty_catches
    } on Object {} finally {}
  }

  static Future<void> login(String method) async {
    try {
      Future.wait([
        metricaAppEvents.reportEvent(name: 'login', attributes: {'method': method}),
      ]);
      // ignore: empty_catches
    } on Object {} finally {}
  }
}
