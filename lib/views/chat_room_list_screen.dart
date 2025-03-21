import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/models/chat_room.dart';
import 'package:realtime_chat_app/provider/chat_provider.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';
import 'package:realtime_chat_app/viewmodels/auth_viewmodel.dart';

import '../viewmodels/chat_viewModel.dart';

class ChatRoomListScreen extends ConsumerWidget {
  ChatRoomListScreen({super.key});

  final _roomController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Rooms"),
        actions: [
          IconButton(
              onPressed: ref.read(authViewModelProvider).signOut,
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _roomController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "New Room Name"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      ref
                          .read(chatViewModelProvider)
                          .createChatRoom(_roomController.text);
                      _roomController.clear();
                    },
                    child: Text("Create Room"))
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chat_rooms')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    final rooms = snapshot.data!.docs
                        .map((doc) => ChatRoom(id: doc.id, name: doc['name']))
                        .toList();
                    return ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (ctx, index) {
                          final room = rooms[index];
                          return ListTile(
                            title: Text(room.name),
                            onTap: () {
                              ref.read(chatRoomProvider.notifier).state = room;
                            },
                          );
                        });
                  })),
        ],
      ),
    );
  }
}
