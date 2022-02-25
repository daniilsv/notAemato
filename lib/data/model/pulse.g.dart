// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pulse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PulseModel _$PulseModelFromJson(Map<String, dynamic> json) {
  return PulseModel(
    avgPulse: (json['avgPulse'] as num?)?.toDouble(),
    restPulse: (json['restPulse'] as num?)?.toDouble(),
    pulse: json['pulse'] == null
        ? null
        : Pulse.fromJson(json['pulse'] as Map<String, dynamic>),
    ts: json['ts'] as int?,
    days: (json['days'] as List<dynamic>?)
        ?.map((e) => PulseDays.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PulseModelToJson(PulseModel instance) =>
    <String, dynamic>{
      'avgPulse': instance.avgPulse,
      'restPulse': instance.restPulse,
      'pulse': instance.pulse,
      'ts': instance.ts,
      'days': instance.days,
    };

Pulse _$PulseFromJson(Map<String, dynamic> json) {
  return Pulse(
    max: json['max'] as int?,
    min: json['min'] as int?,
    norm: json['norm'] as int?,
  );
}

Map<String, dynamic> _$PulseToJson(Pulse instance) => <String, dynamic>{
      'max': instance.max,
      'min': instance.min,
      'norm': instance.norm,
    };

PulseDays _$PulseDaysFromJson(Map<String, dynamic> json) {
  return PulseDays(
    avgPulse: (json['avgPulse'] as num?)?.toDouble(),
    restPulse: (json['restPulse'] as num?)?.toDouble(),
    measurements: (json['measurements'] as List<dynamic>?)
        ?.map((e) => Measurements.fromJson(e as Map<String, dynamic>))
        .toList(),
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$PulseDaysToJson(PulseDays instance) => <String, dynamic>{
      'avgPulse': instance.avgPulse,
      'restPulse': instance.restPulse,
      'ts': instance.ts,
      'measurements': instance.measurements,
    };

Measurements _$MeasurementsFromJson(Map<String, dynamic> json) {
  return Measurements(
    pulse: json['pulse'] as int?,
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$MeasurementsToJson(Measurements instance) =>
    <String, dynamic>{
      'pulse': instance.pulse,
      'ts': instance.ts,
    };
