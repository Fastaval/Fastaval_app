class InfosysNotifications {
  List<InfosysNotification> notifications;

  InfosysNotifications({required this.notifications});

  factory InfosysNotifications.fromJson(dynamic json) {
    List<InfosysNotification> notificationList = List.empty(growable: true);
    for (var activity in json) {
      notificationList.add(InfosysNotification.fromJson(activity));
    }
    return InfosysNotifications(notifications: notificationList);
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

  factory InfosysNotification.fromJson(Map<String, dynamic> json) {
    return InfosysNotification(
      sendTime: json['send_time'],
      en: json['en'],
      da: json['da'],
    );
  }

  Map<String, dynamic> toJson() => {'send_time': sendTime, 'en': en, 'da': da};
}
