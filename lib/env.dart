class Env {
  static const String metricaKey = 'somesome-some-some';
  static const bool deviceTestModeEnabled = false;

  static Map<String, String> wsUrl = {
    'test': 'wss://dev.some.ru',
    'stage': 'wss://stage.some.ru',
    'prod': 'ws://balancer.some.ru',
  };
  static Map<String, String> restUrl = {
    'test': 'https://dev.some.ru/',
    'stage': 'https://stage.some.ru/',
    'prod': 'http://balancer.some.ru/',
  };
}
