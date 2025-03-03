class OttoParty {
  int id;
  String titleEn;
  String titleDa;
  int amount;

  OttoParty(
      {required this.id,
      required this.titleEn,
      required this.titleDa,
      required this.amount});

  factory OttoParty.fromJson(Map<String, dynamic> json) {
    return OttoParty(
      id: json['id'],
      titleEn: json['title_en'],
      titleDa: json['title_da'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title_da': titleDa,
        'title_en': titleEn,
        'amount': amount,
      };
}
