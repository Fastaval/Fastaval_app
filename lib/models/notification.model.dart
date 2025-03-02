class InfosysNotifications {
  List<InfosysNotification> notifications = List.empty(growable: true);

  InfosysNotifications({required this.notifications});

  InfosysNotifications.fromJson(dynamic json) {
    for (var activity in json) {
      notifications.add(InfosysNotification.fromJson(activity));
    }
  }
}

class InfosysNotification {
  int sendTime;
  String en;
  String da;

  InfosysNotification({
    required this.sendTime,
    required this.en,
    required this.da,
  });

  InfosysNotification.fromJson(dynamic json)
    : sendTime = json['send_time'],
      en = json['en'],
      da = json['da'];

  Map<String, dynamic> toJson() => {'send_time': sendTime, 'en': en, 'da': da};
}
