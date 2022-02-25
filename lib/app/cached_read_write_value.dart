import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class CachedReadWriteValue<T> extends ChangeNotifier {
  CachedReadWriteValue(
    this.key, {
    required T? defaultValue,
    required this.ttl,
    FutureOr<T?> Function()? update,
    this.onValue,
    Object Function(T?)? encoder,
    T? Function(dynamic)? decoder,
  })  : value = ReadWriteValue<T>(
          key,
          defaultValue,
          encoder: encoder,
          decoder: decoder,
        ),
        lastUpdate = ReadWriteValue<DateTime>(
          '${key}_last_update',
          DateTime.fromMillisecondsSinceEpoch(0),
          encoder: (o) => o?.millisecondsSinceEpoch ?? 0,
          decoder: (o) => DateTime.fromMillisecondsSinceEpoch(o ?? 0),
        ),
        _update = update {
    onValue?.call(value.val);
  }
  final String key;
  final Duration ttl;
  final FutureOr<T?> Function()? _update;
  final Function(T?)? onValue;
  final ReadWriteValue<T?> value;
  final ReadWriteValue<DateTime> lastUpdate;
  bool _isBusy = false;
  Future<void> update({bool force = false}) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      if (force || DateTime.now().difference(lastUpdate.val!) >= ttl) {
        val = await _update?.call();
        onValue?.call(val);
      }
    } finally {
      _isBusy = false;
    }
  }

  T? get val {
    update();
    return value.val;
  }

  set val(T? newVal) {
    value.val = newVal;
    lastUpdate.val = DateTime.now();
    notifyListeners();
  }
}
