import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:stacked/stacked.dart';

class TestUiViewModel extends BaseViewModel {
  TestUiViewModel() {
    //
  }
  // Services
  final SocketApi api = locator<SocketApi>();

  // Constants

  // Controllers

  // Variables
  bool secondScaf = false;
  // Logic

  Future onReady() async {
    //
  }
  void toggleSecondScaf() {
    secondScaf = !secondScaf;
    notifyListeners();
  }

  Future<void> deleteDevice(String regCode) async {
    final ref = await api.deleteDevice(regCode);
    if (ref == 0) onReady();
    if (ref != 0) return;
  }
}
