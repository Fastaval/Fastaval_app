class Session {
  int? id;
  int? activityId;
  String? roomId;
  String? roomName;
  int? start;
  int? linked;
  double? length;
  int? stop;

  Session(
      {this.activityId,
      this.id,
      this.length,
      this.linked,
      this.roomId,
      this.roomName,
      this.start,
      this.stop});

  Session.fromJson(dynamic json) {
    id = json['afvikling_id'];
    activityId = json['aktivitet_id'];
    length = json['length'];
    linked = json['linked'];
    roomId = json['lokale_id'];
    roomName = json['lokale_navn'];
    start = json['start'];
    stop = json['stop'];
  }
}
