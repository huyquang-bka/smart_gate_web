import '../models/event_ai.dart';
import '../models/event_image_video.dart';

void updateEventAiWithImageVideo(
    EventAi eventAi, EventImageVideo eventImageVideo) {
  eventAi.imgTractor ??= eventImageVideo.imgTractor;
  eventAi.imgTrailer ??= eventImageVideo.imgTrailer;
  eventAi.imgFront1 ??= eventImageVideo.imgFront1;
  eventAi.imgFront2 ??= eventImageVideo.imgFront2;
  eventAi.imgDoor1 ??= eventImageVideo.imgDoor1;
  eventAi.imgDoor2 ??= eventImageVideo.imgDoor2;
  eventAi.imgTop1 ??= eventImageVideo.imgTop1;
  eventAi.imgRight1 ??= eventImageVideo.imgRight1;
  eventAi.imgLeft1 ??= eventImageVideo.imgLeft1;
  eventAi.imgTop2 ??= eventImageVideo.imgTop2;
  eventAi.imgRight2 ??= eventImageVideo.imgRight2;
  eventAi.imgLeft2 ??= eventImageVideo.imgLeft2;

  eventAi.vidTop ??= eventImageVideo.vidTop;
  eventAi.vidRight ??= eventImageVideo.vidRight;
  eventAi.vidLeft ??= eventImageVideo.vidLeft;
  eventAi.vidFront ??= eventImageVideo.vidFront;
  eventAi.vidTractor ??= eventImageVideo.vidTractor;
  eventAi.vidTrailer ??= eventImageVideo.vidTrailer;
}
