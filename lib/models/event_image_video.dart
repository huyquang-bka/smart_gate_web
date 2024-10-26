import 'package:flutter/foundation.dart';

@immutable
class EventImageVideo {
  final int id;
  final String idHistoryInOutAreaPort;
  final String? imgTractor;
  final String? imgTrailer;
  final String? imgFront1;
  final String? imgFront2;
  final String? imgDoor1;
  final String? imgDoor2;
  final String? imgTop1;
  final String? imgRight1;
  final String? imgLeft1;
  final String? imgTop2;
  final String? imgRight2;
  final String? imgLeft2;
  final String? vidTop;
  final String? vidRight;
  final String? vidLeft;
  final String? vidFront;
  final String? vidDoor;
  final String? vidTractor;
  final String? vidTrailer;

  const EventImageVideo({
    required this.id,
    required this.idHistoryInOutAreaPort,
    this.imgTractor,
    this.imgTrailer,
    this.imgFront1,
    this.imgFront2,
    this.imgDoor1,
    this.imgDoor2,
    this.imgTop1,
    this.imgRight1,
    this.imgLeft1,
    this.imgTop2,
    this.imgRight2,
    this.imgLeft2,
    this.vidTop,
    this.vidRight,
    this.vidLeft,
    this.vidFront,
    this.vidDoor,
    this.vidTractor,
    this.vidTrailer,
  });

  factory EventImageVideo.fromJson(Map<String, dynamic> json) {
    String? removeServiceFiles(String? value) {
      return value != null ? value.replaceAll('Service/files/', '') : null;
    }

    return EventImageVideo(
      id: json['id'] as int,
      idHistoryInOutAreaPort: json['idHistoryInOutAreaPort'] as String,
      imgTractor: removeServiceFiles(json['imgTractor'] as String?),
      imgTrailer: removeServiceFiles(json['imgTrailer'] as String?),
      imgFront1: removeServiceFiles(json['imgFront1'] as String?),
      imgFront2: removeServiceFiles(json['imgFront2'] as String?),
      imgDoor1: removeServiceFiles(json['imgDoor1'] as String?),
      imgDoor2: removeServiceFiles(json['imgDoor2'] as String?),
      imgTop1: removeServiceFiles(json['imgTop1'] as String?),
      imgRight1: removeServiceFiles(json['imgRight1'] as String?),
      imgLeft1: removeServiceFiles(json['imgLeft1'] as String?),
      imgTop2: removeServiceFiles(json['imgTop2'] as String?),
      imgRight2: removeServiceFiles(json['imgRight2'] as String?),
      imgLeft2: removeServiceFiles(json['imgLeft2'] as String?),
      vidTop: removeServiceFiles(json['vidTop'] as String?),
      vidRight: removeServiceFiles(json['vidRight'] as String?),
      vidLeft: removeServiceFiles(json['vidLeft'] as String?),
      vidFront: removeServiceFiles(json['vidFront'] as String?),
      vidDoor: removeServiceFiles(json['vidDoor'] as String?),
      vidTractor: removeServiceFiles(json['vidTractor'] as String?),
      vidTrailer: removeServiceFiles(json['vidTrailer'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idHistoryInOutAreaPort': idHistoryInOutAreaPort,
      'imgTractor': imgTractor,
      'imgTrailer': imgTrailer,
      'imgFront1': imgFront1,
      'imgFront2': imgFront2,
      'imgDoor1': imgDoor1,
      'imgDoor2': imgDoor2,
      'imgTop1': imgTop1,
      'imgRight1': imgRight1,
      'imgLeft1': imgLeft1,
      'imgTop2': imgTop2,
      'imgRight2': imgRight2,
      'imgLeft2': imgLeft2,
      'vidTop': vidTop,
      'vidRight': vidRight,
      'vidLeft': vidLeft,
      'vidFront': vidFront,
      'vidDoor': vidDoor,
      'vidTractor': vidTractor,
      'vidTrailer': vidTrailer,
    };
  }
}
