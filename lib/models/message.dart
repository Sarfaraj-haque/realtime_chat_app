class Message {
  Message(
      {required this.id,
      required this.imageUrl,
      required this.senderId,
      required this.content,
      required this.timeStamp});

  final String id;
  final String senderId;
  final String content;
  final String? imageUrl;
  final DateTime timeStamp;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'imageUrl': imageUrl,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
        id: id,
        imageUrl: map['imageUrl'],
        senderId: map['senderId'],
        content: map['content'],
        timeStamp: DateTime.parse(map['timeStamp']));
  }
}
