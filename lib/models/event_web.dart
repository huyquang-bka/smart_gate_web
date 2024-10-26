import 'package:flutter/foundation.dart';

@immutable
class EventWeb {
  final String id;
  final String timeInOutFormat;
  final String? trailerLicensePlate;
  final String? tractorLicensePlate;
  final bool isDamage;
  final String? containerSizeTypeCode1;
  final String? containerSizeTypeCode2;

  const EventWeb({
    required this.id,
    required this.timeInOutFormat,
    required this.trailerLicensePlate,
    required this.tractorLicensePlate,
    required this.isDamage,
    required this.containerSizeTypeCode1,
    required this.containerSizeTypeCode2,
  });

  factory EventWeb.fromJson(Map<String, dynamic> json) {
    return EventWeb(
      id: json['id'] as String,
      timeInOutFormat: json['timeInOutFormat'] as String,
      trailerLicensePlate: json['trailerLicensePlate'] as String?,
      tractorLicensePlate: json['tractorLicensePlate'] as String?,
      isDamage: json['isDamage'] as bool,
      containerSizeTypeCode1: json['containerSizeTypeCode1'] as String?,
      containerSizeTypeCode2: json['containerSizeTypeCode2'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timeInOutFormat': timeInOutFormat,
      'trailerLicensePlate': trailerLicensePlate ?? '',
      'tractorLicensePlate': tractorLicensePlate ?? '',
      'isDamage': isDamage,
      'containerSizeTypeCode1': containerSizeTypeCode1 ?? '',
      'containerSizeTypeCode2': containerSizeTypeCode2 ?? '',
    };
  }
}
