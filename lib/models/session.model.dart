class Session {
  int id;
  int activityId;
  int roomId;
  String roomName;
  int start;
  int linked;
  double length;
  int stop;

  Session({
    required this.activityId,
    required this.id,
    required this.length,
    required this.linked,
    required this.roomId,
    required this.roomName,
    required this.start,
    required this.stop,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['afvikling_id'] as int,
      activityId: json['aktivitet_id'] as int,
      length: json['length'].toDouble(),
      linked: json['linked'],
      roomId: json['lokale_id'],
      roomName: json['lokale_navn'],
      start: json['start'],
      stop: json['stop'],
    );
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
