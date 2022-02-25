// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i3;

import '../data/api/api.dart' as _i16;
import '../data/api/socket.dart' as _i6;
import '../data/repository/devices.dart' as _i10;
import '../data/repository/geozones.dart' as _i13;
import '../data/repository/persons.dart' as _i5;
import '../data/repository/user.dart' as _i7;
import '../data/services/auth.dart' as _i9;
import '../data/services/devices.dart' as _i11;
import '../data/services/events.dart' as _i12;
import '../data/services/geozones.dart' as _i14;
import '../data/services/intl.dart' as _i18;
import '../data/services/janus.dart' as _i19;
import '../data/services/markers.dart' as _i15;
import '../data/services/messages.dart' as _i17;
import '../data/services/navigator.dart' as _i4;
import '../data/services/persons.dart' as _i8;
import '../data/services/push.dart' as _i20;
import '../data/services/thrid.dart'
    as _i21; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  gh.lazySingleton<_i3.DialogService>(
      () => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<_i3.NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<_i4.NavigatorService>(() => _i4.NavigatorService());
  gh.lazySingleton<_i5.PersonsRepository>(
      () => _i5.PersonsRepository(get<_i6.SocketApi>()));
  gh.lazySingleton<_i3.SnackbarService>(
      () => thirdPartyServicesModule.snackBarService);
  gh.lazySingleton<_i7.UserRepository>(() => _i7.UserRepository());
  gh.lazySingleton<_i8.PersonsService>(() =>
      _i8.PersonsService(get<_i5.PersonsRepository>(), get<_i9.AuthService>()));
  gh.lazySingleton<_i6.SocketApi>(
      () => _i6.SocketApi(get<_i7.UserRepository>()));
  gh.lazySingleton<_i10.DevicesRepository>(
      () => _i10.DevicesRepository(get<_i6.SocketApi>()));
  gh.lazySingleton<_i11.DevicesService>(() => _i11.DevicesService(
      get<_i10.DevicesRepository>(), get<_i9.AuthService>()));
  gh.lazySingleton<_i12.EventsService>(() => _i12.EventsService(
      get<_i11.DevicesService>(),
      get<_i8.PersonsService>(),
      get<_i6.SocketApi>()));
  gh.lazySingleton<_i13.GeozonesRepository>(
      () => _i13.GeozonesRepository(get<_i6.SocketApi>()));
  gh.lazySingleton<_i14.GeozonesService>(() => _i14.GeozonesService(
      get<_i13.GeozonesRepository>(), get<_i9.AuthService>()));
  gh.lazySingleton<_i15.MarkersService>(() => _i15.MarkersService(
      get<_i11.DevicesService>(), get<_i8.PersonsService>(), get<_i16.Api>()));
  gh.lazySingleton<_i17.MessagesService>(() => _i17.MessagesService(
      get<_i11.DevicesService>(),
      get<_i8.PersonsService>(),
      get<_i6.SocketApi>()));
  gh.singleton<_i18.IntlService>(_i18.IntlService());
  gh.singleton<_i19.JanusService>(_i19.JanusService());
  gh.singleton<_i16.Api>(_i16.Api(get<_i7.UserRepository>()));
  gh.singleton<_i9.AuthService>(_i9.AuthService(get<_i7.UserRepository>()));
  gh.singleton<_i20.PushService>(_i20.PushService(get<_i9.AuthService>()));
  return get;
}

class _$ThirdPartyServicesModule extends _i21.ThirdPartyServicesModule {
  @override
  _i3.BottomSheetService get bottomSheetService => _i3.BottomSheetService();
  @override
  _i3.DialogService get dialogService => _i3.DialogService();
  @override
  _i3.NavigationService get navigationService => _i3.NavigationService();
  @override
  _i3.SnackbarService get snackBarService => _i3.SnackbarService();
}
