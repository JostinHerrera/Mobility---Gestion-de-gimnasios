class Chat {
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<Message> messages;
  final bool isOnline;

  const Chat({
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.messages,
    this.isOnline = false,
  });
}

class Message {
  final String text;
  final bool isMine;
  final DateTime time;

  const Message({required this.text, required this.isMine, required this.time});
}

class Story {
  final String name;
  final String avatarUrl;
  final bool isOnline;

  const Story({
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
  });
}
