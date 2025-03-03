class Scheduling {
  String type;
  String activityType;
  int id;
  int scheduleId;
  String titleDa;
  String titleEn;
  String roomDa;
  String roomEn;
  int start;
  int stop;
  String playRoomId;
  String playRoomName;
  String meetRoomId;
  String meetRoomName;

  Scheduling({
    required this.type,
    required this.activityType,
    required this.id,
    required this.scheduleId,
    required this.titleDa,
    required this.titleEn,
    required this.roomDa,
    required this.roomEn,
    required this.start,
    required this.stop,
    required this.playRoomId,
    required this.playRoomName,
    required this.meetRoomId,
    required this.meetRoomName,
  });

  factory Scheduling.fromJson(Map<String, dynamic> json) {
    return Scheduling(
      type: json['type'],
      activityType: json['activity_type'],
      id: json['id'],
      scheduleId: json['schedule_id'],
      titleDa: json['title_da'],
      titleEn: json['title_en'],
      roomDa: json['room_da'],
      roomEn: json['room_en'],
      start: json['start'],
      stop: json['stop'],
      playRoomId: json['play_room_id'] ?? '',
      playRoomName: json['play_room_name'] ?? '',
      meetRoomId: json['meet_room_id'] ?? '',
      meetRoomName: json['meet_room_name'] ?? '',
    );
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
