import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/models/message.dart';
import 'package:realtime_chat_app/provider/auth_provider.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';
import 'package:realtime_chat_app/viewmodels/chat_viewModel.dart';

import '../provider/chat_provider.dart';
import '../provider/text_input_provider.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoom = ref.watch(chatRoomProvider);
    final userId = ref.watch(authProvide);
    final messageAsync = ref.watch(messageProvider);
    if (chatRoom == null || userId == null) {
      return Center(
        child: Text("No Chat Room Selected"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoom.name),
        leading: IconButton(
            onPressed: () => ref.read(navigationProvider.notifier).state =
                AppScreen.chatRoomList,
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Expanded(
                child: messageAsync.when(
                    data: (messages) => ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (ctx, index) {
                          final message = messages[index];
                          final isMe = message.senderId == userId;
                          return _buildChatBubble(message, isMe);
                        }),
                    error: (error, _) => Center(
                          child: Text("Error $error"),
                        ),
                    loading: () => Center(
                          child: CircularProgressIndicator(),
                        ))),
            _buildMessageInput(context, ref, chatRoom.id, userId),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isMe ? Colors.blue[200] : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
            ]),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null)
              Image.network(
                message.imageUrl!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            if (message.content.isNotEmpty)
              Text(
                message.content,
                style: TextStyle(color: Colors.black87),
              ),
            SizedBox(
              height: 5,
            ),
            Text(
              message.timeStamp.toString().substring(11, 16),
              style: TextStyle(fontSize: 12, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildMessageInput(
    BuildContext context, WidgetRef ref, String roomId, String userId) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
    ]),
    child: Row(
      children: [
        IconButton(
          onPressed: () async {
            final imgUrl = await ref
                .read(chatViewModelProvider)
                .uploadImage(roomId, userId);
            if (imgUrl != null) {
              ref
                  .read(chatViewModelProvider)
                  .sendMessage('', userId, roomId, imageUrl: imgUrl);
            }
          },
          icon: Icon(Icons.image),
          color: Colors.blueAccent,
        ),
        Expanded(
            child: TextField(
          onChanged: (value) =>
              ref.read(messageProvider1.notifier).state = value,
          decoration: InputDecoration(
              hintText: "Type a message",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey[200]),
        )),
        IconButton(
            onPressed: () {
              final message = ref.read(messageProvider1);
              if (message.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please Enter a Message")));
                return;
              }
              ref
                  .read(chatViewModelProvider)
                  .sendMessage(message, userId, roomId);
              ref.read(messageProvider1.notifier).state = '';
            },
            icon: Icon(
              Icons.send,
              color: Colors.blueAccent,
            ))
      ],
    ),
  );
}
