import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/services/push.dart';
import 'package:stacked/stacked.dart';

class PushLogsViewModel extends ReactiveViewModel {
  PushLogsViewModel();
  // Services
  final PushService service = locator<PushService>();

  // Constants

  // Controllers

  // Variables
  List<PushLog> get items => service.logs;
  // Logic

  Future onReady() async {
    //
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [service];
}
