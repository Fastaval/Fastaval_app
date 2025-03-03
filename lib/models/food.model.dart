class Food {
  int time;
  int timeEnd;
  String titleDa;
  String titleEn;
  int id;
  int timeId;
  String textDa;
  String textEn;
  int received;

  Food({
    required this.time,
    required this.timeEnd,
    required this.titleDa,
    required this.titleEn,
    required this.id,
    required this.timeId,
    required this.textDa,
    required this.textEn,
    this.received = 0,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      time: json['time'],
      timeEnd: json['time_end'],
      titleDa: json['title_da'],
      titleEn: json['title_en'],
      id: json['food_id'],
      timeId: json['time_id'],
      textDa: json['text_da'],
      textEn: json['text_en'],
      received: json['received'],
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'time_end': timeEnd,
        'title_da': titleDa,
        'title_en': titleEn,
        'food_id': id,
        'time_id': timeId,
        'text_da': textDa,
        'text_en': textEn,
        'received': received,
      };
}
