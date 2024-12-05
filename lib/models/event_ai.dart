import 'package:flutter/foundation.dart';
import 'package:smart_gate_web/models/event_web.dart';

@immutable
// ignore: must_be_immutable
class EventAi {
  final String eventId;
  final int checkPointId;
  final String? containerCode1;
  final String? containerCode2;
  final String timeInOut;
  final String? tractorLicensePlate;
  final String? trailerLicensePlate;

  String? imgDoor1;
  String? imgDoor2;
  String? imgFront1;
  String? imgFront2;
  String? imgLeft1;
  String? imgLeft2;
  String? imgRight1;
  String? imgRight2;
  String? imgTop1;
  String? imgTop2;
  String? imgTractor;
  String? imgTrailer;
  String? vidBehind;
  String? vidFront;
  String? vidLeft;
  String? vidRight;
  String? vidTop;
  String? vidTractor;
  String? vidTrailer;
  bool? isError;
  EventAi({
    required this.eventId,
    required this.checkPointId,
    required this.containerCode1,
    required this.timeInOut,
    required this.tractorLicensePlate,
    required this.trailerLicensePlate,
    required this.containerCode2,
    this.imgDoor1,
    this.imgDoor2,
    this.imgFront1,
    this.imgFront2,
    this.imgLeft1,
    this.imgLeft2,
    this.imgRight1,
    this.imgRight2,
    this.imgTop1,
    this.imgTop2,
    this.imgTractor,
    this.imgTrailer,
    this.vidBehind,
    this.vidFront,
    this.vidLeft,
    this.vidRight,
    this.vidTop,
    this.vidTractor,
    this.vidTrailer,
    this.isError = false,
  });

  factory EventAi.fromJson(Map<String, dynamic> json) {
    return EventAi(
      eventId: json['EventId'] as String,
      checkPointId: json['CheckPointId'] as int,
      containerCode1: json['ContainerCode1'] as String?,
      containerCode2: json['ContainerCode2'] as String?,
      imgDoor1: json['ImgDoor1'] as String?,
      imgDoor2: json['ImgDoor2'] as String?,
      imgFront1: json['ImgFront1'] as String?,
      imgFront2: json['ImgFront2'] as String?,
      imgLeft1: json['ImgLeft1'] as String?,
      imgLeft2: json['ImgLeft2'] as String?,
      imgRight1: json['ImgRight1'] as String?,
      imgRight2: json['ImgRight2'] as String?,
      imgTop1: json['ImgTop1'] as String?,
      imgTop2: json['ImgTop2'] as String?,
      imgTractor: json['ImgTractor'] as String?,
      imgTrailer: json['ImgTrailer'] as String?,
      timeInOut: json['TimeInOut'] as String,
      tractorLicensePlate: json['TractorLicensePlate'] as String?,
      trailerLicensePlate: json['TrailerLicensePlate'] as String?,
      vidBehind: json['VidBehind'] as String?,
      vidFront: json['VidFront'] as String?,
      vidLeft: json['VidLeft'] as String?,
      vidRight: json['VidRight'] as String?,
      vidTop: json['VidTop'] as String?,
      vidTractor: json['VidTractor'] as String?,
      vidTrailer: json['VidTrailer'] as String?,
      isError: json['IsError'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EventId': eventId,
      'CheckPointId': checkPointId,
      'ContainerCode1': containerCode1,
      'ContainerCode2': containerCode2,
      'ImgDoor1': imgDoor1,
      'ImgDoor2': imgDoor2,
      'ImgFront1': imgFront1,
      'ImgFront2': imgFront2,
      'ImgLeft1': imgLeft1,
      'ImgLeft2': imgLeft2,
      'ImgRight1': imgRight1,
      'ImgRight2': imgRight2,
      'ImgTop1': imgTop1,
      'ImgTop2': imgTop2,
      'ImgTractor': imgTractor,
      'ImgTrailer': imgTrailer,
      'TimeInOut': timeInOut,
      'TractorLicensePlate': tractorLicensePlate,
      'TrailerLicensePlate': trailerLicensePlate,
      'VidBehind': vidBehind,
      'VidFront': vidFront,
      'VidLeft': vidLeft,
      'VidRight': vidRight,
      'VidTop': vidTop,
      'VidTractor': vidTractor,
      'VidTrailer': vidTrailer,
      'IsError': isError,
    };
  }
}

EventAi eventWebToEventAi(EventWeb eventWeb) {
  return EventAi(
    eventId: eventWeb.id,
    checkPointId: 0, // Assuming a default value or a way to determine this
    containerCode1: eventWeb.containerSizeTypeCode1,
    containerCode2: eventWeb.containerSizeTypeCode2,
    timeInOut: eventWeb.timeInOutFormat,
    tractorLicensePlate: eventWeb.tractorLicensePlate,
    trailerLicensePlate: eventWeb.trailerLicensePlate,
  );
}
