class Session {
  int? id;
  int? activityId;
  String? roomId;
  String? roomName;
  int? start;
  int? linked;
  double? length;
  int? stop;

  Session({
    this.activityId,
    this.id,
    this.length,
    this.linked,
    this.roomId,
    this.roomName,
    this.start,
    this.stop,
  });

  Session.fromJson(dynamic json) {
    id = json['afvikling_id'] as int;
    activityId = json['aktivitet_id'] as int;
    length = json['length'].toDouble();
    linked = json['linked'];
    roomId = json['lokale_id'];
    roomName = json['lokale_navn'];
    start = json['start'];
    stop = json['stop'];
  }

  Map<String, dynamic> toJson() => {
    'afvikling_id': id,
    'aktivitet_id': activityId,
    'length': length,
    'linked': linked,
    'lokale_id': roomId,
    'lokale_navn': roomName,
    'start': start,
    'stop': stop,
  };
}
