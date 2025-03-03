class ActivityRun {
  final int id;
  final int activity;
  final int? localeId;
  final String localeName;
  final int start;
  final int linked;
  final double length;
  final int stop;

  ActivityRun({
    required this.id,
    required this.activity,
    this.localeId,
    required this.localeName,
    required this.start,
    required this.linked,
    required this.length,
    required this.stop,
  });

  factory ActivityRun.fromJson(Map<String, dynamic> json) {
    return ActivityRun(
      id: json['afvikling_id'] is String
          ? int.parse(json['afvikling_id'])
          : json['afvikling_id'],
      activity: json['aktivitet_id'],
      localeId: json['lokale_id'],
      localeName: json['lokale_navn'],
      start: json['start'],
      linked:
          json['linked'] is String ? int.parse(json['linked']) : json['linked'],
      length: json['length'] + .0,
      stop: json['stop'],
    );
  }
}
