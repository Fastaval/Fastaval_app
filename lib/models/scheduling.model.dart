class Scheduling {
  String? type;
  String? activityType;
  int? id;
  int? scheduleId;
  String? titleDa;
  String? titleEn;
  String? roomDa;
  String? roomEn;
  int? start;
  int? stop;
  String? playRoomId;
  String? playRoomName;
  String? meetRoomId;
  String? meetRoomName;

  Scheduling({
    this.type,
    this.activityType,
    this.id,
    this.scheduleId,
    this.titleDa,
    this.titleEn,
    this.roomDa,
    this.roomEn,
    this.start,
    this.stop,
    this.playRoomId,
    this.playRoomName,
    this.meetRoomId,
    this.meetRoomName,
  });

  Scheduling.fromJson(dynamic json) {
    type = json['type'];
    activityType = json['activity_type'];
    id = json['id'];
    scheduleId = json['schedule_id'];
    titleDa = json['title_da'];
    titleEn = json['title_en'];
    roomDa = json['room_da'];
    roomEn = json['room_en'];
    start = json['start'];
    stop = json['stop'];
    playRoomId = json['play_room_id'];
    playRoomName = json['play_room_name'];
    meetRoomId = json['meet_room_id'];
    meetRoomName = json['meet_room_name'];
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'activity_type': activityType,
    'id': id,
    'schedule_id': scheduleId,
    'title_da': titleDa,
    'title_en': titleEn,
    'room_da': roomDa,
    'room_en': roomEn,
    'start': start,
    'stop': stop,
    'play_room_id': playRoomId,
    'play_room_name': playRoomName,
    'meet_room_id': meetRoomId,
    'meet_room_name': meetRoomName,
  };
}
