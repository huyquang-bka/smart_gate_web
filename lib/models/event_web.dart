import 'package:flutter/foundation.dart';

@immutable
class EventWeb {
  final DateTime timeInOut;
  final String trailerLicensePlate;
  final String tractorLicensePlate;
  final bool isDamage;
  final String sizeTypeCode1;
  final String? sizeTypeCode2;
  final String containerSizeTypeCode1;
  final String? containerSizeTypeCode2;

  const EventWeb({
    required this.timeInOut,
    required this.trailerLicensePlate,
    required this.tractorLicensePlate,
    required this.isDamage,
    required this.sizeTypeCode1,
    required this.containerSizeTypeCode1,
    this.containerSizeTypeCode2,
    this.sizeTypeCode2,
  });

  factory EventWeb.fromJson(Map<String, dynamic> json) {
    return EventWeb(
      timeInOut: DateTime.parse(json['timeInOut'] as String),
      trailerLicensePlate: json['trailerLicensePlate'] as String,
      tractorLicensePlate: json['tractorLicensePlate'] as String,
      isDamage: json['isDamage'] as bool,
      containerSizeTypeCode1: json['containerSizeTypeCode1'] as String,
      containerSizeTypeCode2: json['containerSizeTypeCode2'] as String?,
      sizeTypeCode1: json['sizeTypeCode1'] as String,
      sizeTypeCode2: json['sizeTypeCode2'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeInOut': timeInOut.toIso8601String(),
      'trailerLicensePlate': trailerLicensePlate,
      'tractorLicensePlate': tractorLicensePlate,
      'isDamage': isDamage,
      'sizeTypeCode1': sizeTypeCode1,
      'containerSizeTypeCode1': containerSizeTypeCode1,
      'containerSizeTypeCode2': containerSizeTypeCode2,
      'sizeTypeCode2': sizeTypeCode2,
    };
  }
}
