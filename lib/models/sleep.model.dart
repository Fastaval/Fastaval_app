class Sleep {
  int id;
  int access;
  int mattress;
  String areaName;
  String areaId;

  Sleep({
    required this.id,
    required this.access,
    required this.mattress,
    required this.areaName,
    required this.areaId,
  });

  Sleep.fromJson(dynamic json)
      : id = json['id'],
        access = json['access'],
        mattress = json['mattress'],
        areaName = json['area_name'],
        areaId = json['area_id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'access': access,
        'mattress': mattress,
        'area_name': areaName,
        'area_id': areaId,
      };
}
