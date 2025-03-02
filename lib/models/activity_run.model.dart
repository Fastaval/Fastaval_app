class ActivityRun {
  final int id;
  final int activity;
  final int? localeId;
  final String localeName;
  final int start;
  final int linked;
  final double length;
  final int stop;

  ActivityRun(
    this.id,
    this.activity,
    this.localeId,
    this.localeName,
    this.start,
    this.linked,
    this.length,
    this.stop,
  );

  ActivityRun.fromJson(Map<String, dynamic> json)
    : id =
          json['afvikling_id'] is String
              ? int.parse(json['afvikling_id'])
              : json['afvikling_id'],
      activity = json['aktivitet_id'],
      localeId = json['lokale_id'],
      localeName = json['lokale_navn'],
      start = json['start'],
      linked =
          json['linked'] is String ? int.parse(json['linked']) : json['linked'],
      length = json['length'] + .0,
      stop = json['stop'];
}
