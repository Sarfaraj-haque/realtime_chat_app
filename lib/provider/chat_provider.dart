import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/models/message.dart';

import '../models/chat_room.dart';

final chatRoomProvider = StateProvider<ChatRoom?>((ref) => null);

final messageProvider = StreamProvider<List<Message>>((ref) {
  final chatRoom = ref.watch(chatRoomProvider);
  if (chatRoom == null) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(chatRoom.id)
      .collection('message')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Message.fromMap(doc.id, doc.data()))
          .toList());
});
