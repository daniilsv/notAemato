import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class DeviceModel extends Equatable {
  String? type;
  String? family;
  String? userEmail;
  String? name;
  bool? online;
  int? batteryPercent;
  int? oid;
  double? lat;
  double? lon;
  int? speed;
  int? ts;
  String? photoUrl;
  @JsonKey(name: 'props')
  DeviceProps? deviceProps;
  DeviceStates? states;
  DeviceCaps? caps;
  @JsonKey(name: 'personId')
  int? personId;
  LatLng get location => LatLng(lat!, lon!);
  DeviceModel({
    this.type,
    this.family,
    this.userEmail,
    this.name,
    this.online,
    this.batteryPercent,
    this.oid,
    this.lat,
    this.lon,
    this.speed,
    this.ts,
    this.photoUrl,
    this.deviceProps,
    this.states,
    this.caps,
    this.personId,
  });
  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  factory DeviceModel.fromJson(Map<String, dynamic> json) => _$DeviceModelFromJson(json);

  @override
  List<Object?> get props => [oid];
}

@JsonSerializable()
class DeviceProps {
  String? imei;
  int? checkinPeriod;
  String? enableGeozoneEnterAlert;
  String? enableGeozoneLeaveAlert;
  String? simNumber1;
  @AlarmSerialiser()
  List<AlarmClock>? alarmClock;
  @DndModeSerialiser()
  List<DndMode>? dndMode;
  int? bloodPressureHighMax;
  int? bloodPressureHighMin;
  int? bloodPressureLowMax;
  int? bloodPressureLowMin;
  int? bloodPressureHighNorm;
  int? bloodPressureLowNorm;
  int? heartrateAlertMax;
  int? heartrateAlertMin;
  int? heartrateNorm;
  int? heartratePeriod;
  int? age;
  int? weight;
  int? dailyStepsGoal;
  String? enableRemovalSensor;
  String? enableSmsAlert;
  String? enableStepCounter;
  String? primaryPhoneNumber;
  String? language;
  String? timezone;
  int? profile;
  String? bloodPressureLowAlert;
  String? bloodPressureHighAlert;
  String? pedometerPeriod;
  String? sedentarinessAlert;
  String? whitelistEnabled;
  String? phonebookDialCount;
  @SosPhoneSerialiser()
  List<SosPhone>? sosPhones;
  @PhoneBookSerialiser()
  List<PhonebookPhone>? phonebook; //List<PhonebookPhone>
  String? phoneWhitelist; // ?
  int? bonusPoints;
  String? familyName;
  String? modelName;
  String? enableEnterLeaveAlert;
  int? sedentarinessAlertFromTime;
  int? sedentarinessAlertToTime;
  String? sedentarinessAlertEnabled;
  bool? wifiEnable;
  bool? wifiAvailable;
  int? fallingOffLevel;

  DeviceProps({
    this.sosPhones,
    this.timezone,
    this.bloodPressureHighMin,
    this.bloodPressureHighNorm,
    this.bloodPressureHighMax,
    this.bloodPressureLowMin,
    this.bloodPressureLowNorm,
    this.bloodPressureLowMax,
    this.heartrateAlertMin,
    this.heartrateNorm,
    this.heartrateAlertMax,
    this.checkinPeriod,
    this.bonusPoints,
    this.alarmClock,
    this.enableStepCounter,
    this.enableRemovalSensor,
    this.enableSmsAlert,
    this.dndMode,
    this.familyName,
    this.simNumber1,
    this.phoneWhitelist,
    this.whitelistEnabled,
    this.phonebook,
    this.weight,
    this.age,
    this.dailyStepsGoal,
    this.imei,
    this.modelName,
    this.language,
    this.primaryPhoneNumber,
    this.sedentarinessAlert,
    this.pedometerPeriod,
    this.heartratePeriod,
    this.phonebookDialCount,
    this.enableGeozoneLeaveAlert,
    this.enableGeozoneEnterAlert,
    this.enableEnterLeaveAlert,
    this.profile,
    this.sedentarinessAlertFromTime,
    this.sedentarinessAlertToTime,
    this.sedentarinessAlertEnabled,
    this.bloodPressureLowAlert,
    this.bloodPressureHighAlert,
    this.wifiEnable,
    this.wifiAvailable,
    this.fallingOffLevel,
  });
  Map<String, dynamic> toJson() => _$DevicePropsToJson(this);

  factory DeviceProps.fromJson(Map<String, dynamic> json) => _$DevicePropsFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class AlarmClock {
  List<bool>? repeat;
  int? hours;
  int? minutes;
  bool? enabled;

  AlarmClock({this.repeat, this.hours, this.minutes, this.enabled});

  Map<String, dynamic> toJson() => _$AlarmClockToJson(this);

  factory AlarmClock.fromJson(Map<String, dynamic> json) => _$AlarmClockFromJson(json);
}

@JsonSerializable()
class DndMode {
  int? beginHour;
  int? beginMinute;
  int? endHour;
  int? endMinute;

  DndMode({this.beginHour, this.beginMinute, this.endHour, this.endMinute});

  Map<String, dynamic> toJson() => _$DndModeToJson(this);

  factory DndMode.fromJson(Map<String, dynamic> json) => _$DndModeFromJson(json);
}

@JsonSerializable()
class SosPhone {
  String? phone;

  SosPhone({this.phone});

  Map<String, dynamic> toJson() => _$SosPhoneToJson(this);

  factory SosPhone.fromJson(Map<String, dynamic> json) => _$SosPhoneFromJson(json);
}

@JsonSerializable()
class PhonebookPhone {
  String? phone;
  String? name;
  bool? dial;

  PhonebookPhone({this.phone, this.name, this.dial});

  Map<String, dynamic> toJson() => _$PhonebookPhoneToJson(this);

  factory PhonebookPhone.fromJson(Map<String, dynamic> json) =>
      _$PhonebookPhoneFromJson(json);
}

@JsonSerializable()
class DeviceStates {
  int? gsmSignalLevel;
  int? coordTs;
  int? lbsCoordTs;
  double? lbsLat;
  double? lbsLon;
  int? wifiCoordTs;
  double? wifiLat;
  double? wifiLon;
  int? totalStepCount;

  DeviceStates({
    this.gsmSignalLevel,
    this.coordTs,
    this.lbsCoordTs,
    this.lbsLat,
    this.lbsLon,
    this.wifiCoordTs,
    this.wifiLat,
    this.wifiLon,
    this.totalStepCount,
  });

  Map<String, dynamic> toJson() => _$DeviceStatesToJson(this);

  factory DeviceStates.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatesFromJson(json);
}

@JsonSerializable()
class DeviceCaps {
  @JsonKey(name: 'NO_TAKEOFF')
  String? notakeoff;
  @JsonKey(name: 'SOS_TYPE')
  String? sostype;
  @JsonKey(name: 'CAMERA')
  String? camera;
  @JsonKey(name: 'PEDO_TYPE')
  String? pedotype;
  @JsonKey(name: 'TEXT_MSG')
  String? textmsg;
  @JsonKey(name: 'NO_WHITELIST')
  String? nowhitelist;
  @JsonKey(name: 'PHONEBOOK_15')
  String? phonebook15;
  @JsonKey(name: 'WARMUP')
  String? warmup;
  @JsonKey(name: 'CALIBRATION')
  String? calibration;
  @JsonKey(name: 'HEARTRATE')
  String? heartrate;
  @JsonKey(name: 'PRESSURE')
  String? pressure;
  @JsonKey(name: 'VOICE_MSG')
  String? voicemsg;
  @JsonKey(name: 'FALLING_SENSOR')
  String? fallingsensor;
  @JsonKey(name: 'SEND_IMAGE')
  String? sendimage;
  @JsonKey(name: 'TEXT_MSG_LEN')
  String? textmsglen;

  DeviceCaps({
    this.notakeoff,
    this.sostype,
    this.camera,
    this.pedotype,
    this.textmsg,
    this.nowhitelist,
    this.phonebook15,
    this.warmup,
    this.calibration,
    this.heartrate,
    this.pressure,
    this.voicemsg,
    this.fallingsensor,
    this.sendimage,
    this.textmsglen,
  });

  Map<String, dynamic> toJson() => _$DeviceCapsToJson(this);

  factory DeviceCaps.fromJson(Map<String, dynamic> json) => _$DeviceCapsFromJson(json);
}

class AlarmSerialiser implements JsonConverter<List<AlarmClock>?, String?> {
  const AlarmSerialiser();

  @override
  List<AlarmClock> fromJson(String? json) => json == null
      ? []
      : List.from(jsonDecode(json)).map((e) => _$AlarmClockFromJson(e)).toList();

  @override
  String toJson(List<AlarmClock>? alarmClock) => jsonEncode(alarmClock);
}

class DndModeSerialiser implements JsonConverter<List<DndMode>?, String?> {
  const DndModeSerialiser();

  @override
  List<DndMode> fromJson(String? json) => json == null
      ? []
      : List.from(jsonDecode(json)).map((e) => _$DndModeFromJson(e)).toList();

  @override
  String toJson(List<DndMode>? alarmClock) => jsonEncode(alarmClock);
}

class SosPhoneSerialiser implements JsonConverter<List<SosPhone>?, String?> {
  const SosPhoneSerialiser();

  @override
  List<SosPhone> fromJson(String? json) => json == null
      ? []
      : List.from(jsonDecode(json)).map((e) => _$SosPhoneFromJson(e)).toList();

  @override
  String toJson(List<SosPhone>? alarmClock) => jsonEncode(alarmClock);
}

class PhoneBookSerialiser implements JsonConverter<List<PhonebookPhone>?, String?> {
  const PhoneBookSerialiser();

  @override
  List<PhonebookPhone> fromJson(String? json) => json == null
      ? []
      : List.from(jsonDecode(json)).map((e) => _$PhonebookPhoneFromJson(e)).toList();

  @override
  String toJson(List<PhonebookPhone>? alarmClock) => jsonEncode(alarmClock);
}
