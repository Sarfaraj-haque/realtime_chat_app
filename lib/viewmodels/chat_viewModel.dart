import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatViewModelProvider = Provider((ref) => ChatViewModel(ref));

class ChatViewModel {
  ChatViewModel(this._ref);

  final Ref _ref;

  Future<void> createChatRoom(String name) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .add({'name': name});
  }

  Future<void> sendMessage(
      String content, String senderId, String roomId) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(roomId)
        .collection('message')
        .add({
      'senderId': senderId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
