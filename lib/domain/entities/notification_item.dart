class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.season,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final String season; // 'heat' | 'cold' | 'normal'
  final DateTime createdAt;
  final bool isRead;

  bool get isHeat => season == 'heat';
  bool get isCold => season == 'cold';

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        id: id,
        title: title,
        body: body,
        season: season,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'season': season,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'isRead': isRead,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        season: json['season'] as String? ?? 'normal',
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
        isRead: json['isRead'] as bool? ?? false,
      );
}
