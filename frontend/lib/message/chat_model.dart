class ChatThreadModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String image;
  final String unreadCount;
  final bool isOnline;

  ChatThreadModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.image,
    required this.unreadCount,
    required this.isOnline,
  });
}

class ChatMessageModel {
  final String id;
  final String text;
  final bool isSender; // true jika ini pesan yang kita kirim

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isSender,
  });
}