import 'dart:async';
import 'dart:io';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/api.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/dto/auth_credentials.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/repository/user.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:supercharged/supercharged.dart';

abstract class OnAuthListener {
  void onUser(UserModel user);
  void onExit();
}

@singleton
class AuthService {
  AuthService(this._userRepository) {
    _userRepository.userModel.listen(
      (_newCred) {
        if (_userModel?.id != null &&
            _userRepository.userModel.val?.id != null &&
            _userModel?.id == _userRepository.userModel.val?.id) return;
        final cbs = _authListeners.toList();
        if (_newCred?['id'] == null) {
          _userModel = null;
          for (final listener in cbs) {
            listener.onExit();
          }
        } else {
          _userModel = _userRepository.userModel.val;
          for (final listener in cbs) {
            listener.onUser(_userRepository.userModel.val!);
          }
        }
      },
    );
    if (_userRepository.authModel.val?.email != null)
      initSignIn();
    else
      logout();
  }

  late final UserRepository _userRepository;
  UserModel? _userModel;

  final Set<OnAuthListener> _authListeners = <OnAuthListener>{};

  final SocketApi api = locator<SocketApi>();

  UserModel? get user => _userRepository.userModel.val;
  bool get isNewUser => user!.skytag == '${_userRepository.authModel.val!.email}#';
  bool get isLoggedIn => user?.id != null;

  void addAuthListener(OnAuthListener listener) {
    _authListeners.add(listener);
    if (_userRepository.userModel.val?.id != null)
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        listener.onUser(_userRepository.userModel.val!);
      });
  }

  void removeAuthListener(OnAuthListener listener) {
    _authListeners.remove(listener);
  }

  Future<void> initSignIn([AuthCredentials? cred]) async {
    api.close();
    if (await api.auth(cred) == null) logout();
  }

  Future<void> signIn([AuthCredentials? cred]) async {
    SocketError? lastErr;
    SocketError? _lastErr;
    for (int i = 0; i < 3; i++) {
      try {
        api.close();
        await Future<void>.delayed(500.milliseconds);
        final d = await Future.any<dynamic>([
          api.auth(cred),
          Future<void>.delayed(2.seconds, () => false),
        ]);
        if (d is UserModel?) {
          lastErr = null;
          _lastErr = null;
          break;
        }
        await Future<void>.delayed(500.milliseconds);
        logout();
      } on SocketError catch (e) {
        if (e != SocketError.noInternet) lastErr = e;
        _lastErr = e;
      } finally {}
    }
    if (lastErr != null || _lastErr != null) throw lastErr ?? _lastErr!;
  }

  void saveAuthCred(AuthCredentials cred, UserModel userModel) {
    _userRepository.authModel.val = cred;
    _userRepository.userModel.val = userModel;
  }

  void logout() {
    api.close();
    _userRepository.authModel.val = null;
    _userRepository.userModel.val = null;
    // _authListeners.clear();
  }

  Future<void> updateSkytag(String text) async {
    await api.setSkytag(text);
    await api.setVideocallProfile(name: text);
    _userRepository.userModel.val = UserModel.fromJson({
      ..._userRepository.userModel.val!.toJson(),
      'skytag': text,
    });
  }

  Future<void> updatePhoto(File? localPhoto) async {
    final uploadUrl = await (api.getUploadProfilePhotoUrl() as FutureOr<String>);
    final ret = await locator<Api>().upload.upload(url: uploadUrl, file: localPhoto);

    _userRepository.userModel.val = UserModel.fromJson({
      ..._userRepository.userModel.val!.toJson(),
      'photo': ret.photoUrl,
    });
  }
}
