import 'package:notaemato/app/locator.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';

enum SnackbarType { error, primary }
void setupSnackBar() {
  final service = locator<SnackbarService>();

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.error,
    config: SnackbarConfig(
      backgroundColor: AppColors.error,
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.primary,
    config: SnackbarConfig(
      backgroundColor: AppColors.bg,
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
    ),
  );
}

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  SnackbarService get snackBarService;
  @lazySingleton
  BottomSheetService get bottomSheetService;
}
