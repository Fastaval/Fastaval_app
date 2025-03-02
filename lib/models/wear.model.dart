class Wear {
  int amount;
  String titleDa;
  String titleEn;
  int wearId;
  int received;

  Wear({
    required this.amount,
    required this.titleDa,
    required this.titleEn,
    required this.wearId,
    required this.received,
  });

  Wear.fromJson(dynamic json)
    : amount = json['amount'],
      titleDa = json['title_da'],
      titleEn = json['title_en'],
      wearId = json['wear_id'],
      received = json['received'];

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'title_da': titleDa,
    'title_en': titleEn,
    'wear_id': wearId,
    'received': received,
  };
}
