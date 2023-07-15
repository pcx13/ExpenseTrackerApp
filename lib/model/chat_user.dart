class ChatUser {
  final String id;
  final String name;
  final String avatar;
  final String pushToken;

  ChatUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.pushToken,
  });

  static ChatUser fromJson(Map<String, dynamic> json) => ChatUser(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
        pushToken: json['pushToken'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'pushToken': pushToken,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
