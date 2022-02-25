import 'package:json_annotation/json_annotation.dart';

part 'pulse.g.dart';

@JsonSerializable()
class PulseModel {
  double? avgPulse;
  double? restPulse;
  Pulse? pulse;
  int? ts;
  List<PulseDays>? days;

  PulseModel({
    this.avgPulse,
    this.restPulse,
    this.pulse,
    this.ts,
    this.days,
  });
  Map<String, dynamic> toJson() => _$PulseModelToJson(this);

  factory PulseModel.fromJson(Map<String, dynamic> json) => _$PulseModelFromJson(json);
}

@JsonSerializable()
class Pulse {
  int? max;
  int? min;
  int? norm;

  Pulse({
    this.max,
    this.min,
    this.norm,
  });
  Map<String, dynamic> toJson() => _$PulseToJson(this);

  factory Pulse.fromJson(Map<String, dynamic> json) => _$PulseFromJson(json);
}

@JsonSerializable()
class PulseDays {
  double? avgPulse;
  double? restPulse;
  int? ts;
  List<Measurements>? measurements;

  PulseDays({
    this.avgPulse,
    this.restPulse,
    this.measurements,
    this.ts,
  });
  Map<String, dynamic> toJson() => _$PulseDaysToJson(this);

  factory PulseDays.fromJson(Map<String, dynamic> json) => _$PulseDaysFromJson(json);
}

@JsonSerializable()
class Measurements {
  int? pulse;
  int? ts;

  Measurements({
    this.pulse,
    this.ts,
  });
  Map<String, dynamic> toJson() => _$MeasurementsToJson(this);

  factory Measurements.fromJson(Map<String, dynamic> json) =>
      _$MeasurementsFromJson(json);
}
