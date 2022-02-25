// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) {
  return DeviceModel(
    type: json['type'] as String?,
    family: json['family'] as String?,
    userEmail: json['userEmail'] as String?,
    name: json['name'] as String?,
    online: json['online'] as bool?,
    batteryPercent: json['batteryPercent'] as int?,
    oid: json['oid'] as int?,
    lat: (json['lat'] as num?)?.toDouble(),
    lon: (json['lon'] as num?)?.toDouble(),
    speed: json['speed'] as int?,
    ts: json['ts'] as int?,
    photoUrl: json['photoUrl'] as String?,
    deviceProps: json['props'] == null
        ? null
        : DeviceProps.fromJson(json['props'] as Map<String, dynamic>),
    states: json['states'] == null
        ? null
        : DeviceStates.fromJson(json['states'] as Map<String, dynamic>),
    caps: json['caps'] == null
        ? null
        : DeviceCaps.fromJson(json['caps'] as Map<String, dynamic>),
    personId: json['personId'] as int?,
  );
}

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'family': instance.family,
      'userEmail': instance.userEmail,
      'name': instance.name,
      'online': instance.online,
      'batteryPercent': instance.batteryPercent,
      'oid': instance.oid,
      'lat': instance.lat,
      'lon': instance.lon,
      'speed': instance.speed,
      'ts': instance.ts,
      'photoUrl': instance.photoUrl,
      'props': instance.deviceProps,
      'states': instance.states,
      'caps': instance.caps,
      'personId': instance.personId,
    };

DeviceProps _$DevicePropsFromJson(Map<String, dynamic> json) {
  return DeviceProps(
    sosPhones:
        const SosPhoneSerialiser().fromJson(json['sosPhones'] as String?),
    timezone: json['timezone'] as String?,
    bloodPressureHighMin: json['bloodPressureHighMin'] as int?,
    bloodPressureHighNorm: json['bloodPressureHighNorm'] as int?,
    bloodPressureHighMax: json['bloodPressureHighMax'] as int?,
    bloodPressureLowMin: json['bloodPressureLowMin'] as int?,
    bloodPressureLowNorm: json['bloodPressureLowNorm'] as int?,
    bloodPressureLowMax: json['bloodPressureLowMax'] as int?,
    heartrateAlertMin: json['heartrateAlertMin'] as int?,
    heartrateNorm: json['heartrateNorm'] as int?,
    heartrateAlertMax: json['heartrateAlertMax'] as int?,
    checkinPeriod: json['checkinPeriod'] as int?,
    bonusPoints: json['bonusPoints'] as int?,
    alarmClock: const AlarmSerialiser().fromJson(json['alarmClock'] as String?),
    enableStepCounter: json['enableStepCounter'] as String?,
    enableRemovalSensor: json['enableRemovalSensor'] as String?,
    enableSmsAlert: json['enableSmsAlert'] as String?,
    dndMode: const DndModeSerialiser().fromJson(json['dndMode'] as String?),
    familyName: json['familyName'] as String?,
    simNumber1: json['simNumber1'] as String?,
    phoneWhitelist: json['phoneWhitelist'] as String?,
    whitelistEnabled: json['whitelistEnabled'] as String?,
    phonebook:
        const PhoneBookSerialiser().fromJson(json['phonebook'] as String?),
    weight: json['weight'] as int?,
    age: json['age'] as int?,
    dailyStepsGoal: json['dailyStepsGoal'] as int?,
    imei: json['imei'] as String?,
    modelName: json['modelName'] as String?,
    language: json['language'] as String?,
    primaryPhoneNumber: json['primaryPhoneNumber'] as String?,
    sedentarinessAlert: json['sedentarinessAlert'] as String?,
    pedometerPeriod: json['pedometerPeriod'] as String?,
    heartratePeriod: json['heartratePeriod'] as int?,
    phonebookDialCount: json['phonebookDialCount'] as String?,
    enableGeozoneLeaveAlert: json['enableGeozoneLeaveAlert'] as String?,
    enableGeozoneEnterAlert: json['enableGeozoneEnterAlert'] as String?,
    enableEnterLeaveAlert: json['enableEnterLeaveAlert'] as String?,
    profile: json['profile'] as int?,
    sedentarinessAlertFromTime: json['sedentarinessAlertFromTime'] as int?,
    sedentarinessAlertToTime: json['sedentarinessAlertToTime'] as int?,
    sedentarinessAlertEnabled: json['sedentarinessAlertEnabled'] as String?,
    bloodPressureLowAlert: json['bloodPressureLowAlert'] as String?,
    bloodPressureHighAlert: json['bloodPressureHighAlert'] as String?,
    wifiEnable: json['wifiEnable'] as bool?,
    wifiAvailable: json['wifiAvailable'] as bool?,
    fallingOffLevel: json['fallingOffLevel'] as int?,
  );
}

Map<String, dynamic> _$DevicePropsToJson(DeviceProps instance) =>
    <String, dynamic>{
      'imei': instance.imei,
      'checkinPeriod': instance.checkinPeriod,
      'enableGeozoneEnterAlert': instance.enableGeozoneEnterAlert,
      'enableGeozoneLeaveAlert': instance.enableGeozoneLeaveAlert,
      'simNumber1': instance.simNumber1,
      'alarmClock': const AlarmSerialiser().toJson(instance.alarmClock),
      'dndMode': const DndModeSerialiser().toJson(instance.dndMode),
      'bloodPressureHighMax': instance.bloodPressureHighMax,
      'bloodPressureHighMin': instance.bloodPressureHighMin,
      'bloodPressureLowMax': instance.bloodPressureLowMax,
      'bloodPressureLowMin': instance.bloodPressureLowMin,
      'bloodPressureHighNorm': instance.bloodPressureHighNorm,
      'bloodPressureLowNorm': instance.bloodPressureLowNorm,
      'heartrateAlertMax': instance.heartrateAlertMax,
      'heartrateAlertMin': instance.heartrateAlertMin,
      'heartrateNorm': instance.heartrateNorm,
      'heartratePeriod': instance.heartratePeriod,
      'age': instance.age,
      'weight': instance.weight,
      'dailyStepsGoal': instance.dailyStepsGoal,
      'enableRemovalSensor': instance.enableRemovalSensor,
      'enableSmsAlert': instance.enableSmsAlert,
      'enableStepCounter': instance.enableStepCounter,
      'primaryPhoneNumber': instance.primaryPhoneNumber,
      'language': instance.language,
      'timezone': instance.timezone,
      'profile': instance.profile,
      'bloodPressureLowAlert': instance.bloodPressureLowAlert,
      'bloodPressureHighAlert': instance.bloodPressureHighAlert,
      'pedometerPeriod': instance.pedometerPeriod,
      'sedentarinessAlert': instance.sedentarinessAlert,
      'whitelistEnabled': instance.whitelistEnabled,
      'phonebookDialCount': instance.phonebookDialCount,
      'sosPhones': const SosPhoneSerialiser().toJson(instance.sosPhones),
      'phonebook': const PhoneBookSerialiser().toJson(instance.phonebook),
      'phoneWhitelist': instance.phoneWhitelist,
      'bonusPoints': instance.bonusPoints,
      'familyName': instance.familyName,
      'modelName': instance.modelName,
      'enableEnterLeaveAlert': instance.enableEnterLeaveAlert,
      'sedentarinessAlertFromTime': instance.sedentarinessAlertFromTime,
      'sedentarinessAlertToTime': instance.sedentarinessAlertToTime,
      'sedentarinessAlertEnabled': instance.sedentarinessAlertEnabled,
      'wifiEnable': instance.wifiEnable,
      'wifiAvailable': instance.wifiAvailable,
      'fallingOffLevel': instance.fallingOffLevel,
    };

AlarmClock _$AlarmClockFromJson(Map<String, dynamic> json) {
  return AlarmClock(
    repeat: (json['repeat'] as List<dynamic>?)?.map((e) => e as bool).toList(),
    hours: json['hours'] as int?,
    minutes: json['minutes'] as int?,
    enabled: json['enabled'] as bool?,
  );
}

Map<String, dynamic> _$AlarmClockToJson(AlarmClock instance) =>
    <String, dynamic>{
      'repeat': instance.repeat,
      'hours': instance.hours,
      'minutes': instance.minutes,
      'enabled': instance.enabled,
    };

DndMode _$DndModeFromJson(Map<String, dynamic> json) {
  return DndMode(
    beginHour: json['beginHour'] as int?,
    beginMinute: json['beginMinute'] as int?,
    endHour: json['endHour'] as int?,
    endMinute: json['endMinute'] as int?,
  );
}

Map<String, dynamic> _$DndModeToJson(DndMode instance) => <String, dynamic>{
      'beginHour': instance.beginHour,
      'beginMinute': instance.beginMinute,
      'endHour': instance.endHour,
      'endMinute': instance.endMinute,
    };

SosPhone _$SosPhoneFromJson(Map<String, dynamic> json) {
  return SosPhone(
    phone: json['phone'] as String?,
  );
}

Map<String, dynamic> _$SosPhoneToJson(SosPhone instance) => <String, dynamic>{
      'phone': instance.phone,
    };

PhonebookPhone _$PhonebookPhoneFromJson(Map<String, dynamic> json) {
  return PhonebookPhone(
    phone: json['phone'] as String?,
    name: json['name'] as String?,
    dial: json['dial'] as bool?,
  );
}

Map<String, dynamic> _$PhonebookPhoneToJson(PhonebookPhone instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'dial': instance.dial,
    };

DeviceStates _$DeviceStatesFromJson(Map<String, dynamic> json) {
  return DeviceStates(
    gsmSignalLevel: json['gsmSignalLevel'] as int?,
    coordTs: json['coordTs'] as int?,
    lbsCoordTs: json['lbsCoordTs'] as int?,
    lbsLat: (json['lbsLat'] as num?)?.toDouble(),
    lbsLon: (json['lbsLon'] as num?)?.toDouble(),
    wifiCoordTs: json['wifiCoordTs'] as int?,
    wifiLat: (json['wifiLat'] as num?)?.toDouble(),
    wifiLon: (json['wifiLon'] as num?)?.toDouble(),
    totalStepCount: json['totalStepCount'] as int?,
  );
}

Map<String, dynamic> _$DeviceStatesToJson(DeviceStates instance) =>
    <String, dynamic>{
      'gsmSignalLevel': instance.gsmSignalLevel,
      'coordTs': instance.coordTs,
      'lbsCoordTs': instance.lbsCoordTs,
      'lbsLat': instance.lbsLat,
      'lbsLon': instance.lbsLon,
      'wifiCoordTs': instance.wifiCoordTs,
      'wifiLat': instance.wifiLat,
      'wifiLon': instance.wifiLon,
      'totalStepCount': instance.totalStepCount,
    };

DeviceCaps _$DeviceCapsFromJson(Map<String, dynamic> json) {
  return DeviceCaps(
    notakeoff: json['NO_TAKEOFF'] as String?,
    sostype: json['SOS_TYPE'] as String?,
    camera: json['CAMERA'] as String?,
    pedotype: json['PEDO_TYPE'] as String?,
    textmsg: json['TEXT_MSG'] as String?,
    nowhitelist: json['NO_WHITELIST'] as String?,
    phonebook15: json['PHONEBOOK_15'] as String?,
    warmup: json['WARMUP'] as String?,
    calibration: json['CALIBRATION'] as String?,
    heartrate: json['HEARTRATE'] as String?,
    pressure: json['PRESSURE'] as String?,
    voicemsg: json['VOICE_MSG'] as String?,
    fallingsensor: json['FALLING_SENSOR'] as String?,
    sendimage: json['SEND_IMAGE'] as String?,
    textmsglen: json['TEXT_MSG_LEN'] as String?,
  );
}

Map<String, dynamic> _$DeviceCapsToJson(DeviceCaps instance) =>
    <String, dynamic>{
      'NO_TAKEOFF': instance.notakeoff,
      'SOS_TYPE': instance.sostype,
      'CAMERA': instance.camera,
      'PEDO_TYPE': instance.pedotype,
      'TEXT_MSG': instance.textmsg,
      'NO_WHITELIST': instance.nowhitelist,
      'PHONEBOOK_15': instance.phonebook15,
      'WARMUP': instance.warmup,
      'CALIBRATION': instance.calibration,
      'HEARTRATE': instance.heartrate,
      'PRESSURE': instance.pressure,
      'VOICE_MSG': instance.voicemsg,
      'FALLING_SENSOR': instance.fallingsensor,
      'SEND_IMAGE': instance.sendimage,
      'TEXT_MSG_LEN': instance.textmsglen,
    };
